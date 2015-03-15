//
//  DTWebService.m
//
//  Created by Dimitris-Sotiris Tsolis on 1/9/14.
//  Copyright (c) 2014 Dimitris-Sotiris Tsolis. All rights reserved.
//

#import "DTWebService.h"

@implementation NSURLRequest (DTWebService_NSURLRequest)

+ (NSURLRequest *)requestWithURL:(NSURL *)url httpHeaders:(NSDictionary *)headers {
    return [NSURLRequest requestWithURL:url httpHeaders:headers file:nil fileName:nil];
}

+ (NSURLRequest *)requestWithURL:(NSURL *)url file:(NSData *)fileData  fileName:(NSString *)fileName {
    return [NSURLRequest requestWithURL:url httpHeaders:nil file:fileData fileName:fileName];
}

+ (NSURLRequest *)requestWithURL:(NSURL *)url httpHeaders:(NSDictionary *)headers file:(NSData *)fileData fileName:(NSString *)fileName
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (headers) {
        for (NSString *key in headers.allKeys) {
            [request addValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    if (fileData) {
        if (fileName.length == 0)
            fileName = @"file";
        
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fileupload\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:fileData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
    }
    
    return request;
}

@end



@interface DTWebService() <NSURLConnectionDelegate>
{
    NSURLRequest     *_request;
    NSMutableData    *_receivedData;
    NSURLConnection  *_connection;
    NSStringEncoding _encoding;
    NSNumber         *_fileSize;
}


@end

@implementation DTWebService

+ (instancetype)sharedInstance
{
    static DTWebService *instance = nil;
    if (instance == nil)
    {
        instance = [[[self class] alloc] init];
    }
    return instance;
}



/*
 * Initializers
 * ============================ */
+ (instancetype)webServiceWithURL:(NSURL *)url {
    return [[DTWebService alloc] initWithURL:url];
}

+ (instancetype)webServiceWithRequest:(NSURLRequest *)request {
    return [[DTWebService alloc] initWithRequest:request];
}

+ (instancetype)trustedWebServiceWithURL:(NSURL *)url {
    DTWebService *webService = [[self class] webServiceWithURL:url];
    webService.trustedHosts = @[url.host];
    webService.allowNewIfBusy= NO;
    return webService;
}

+ (instancetype)trustedWebServiceWithRequest:(NSURLRequest *)request {
    DTWebService *webService = [[self class] webServiceWithRequest:request];
    webService.trustedHosts = @[request.URL.host];
    webService.allowNewIfBusy = NO;
    return webService;
}

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        _allowNewIfBusy = NO;
        self.url = url;
        _request = [NSURLRequest requestWithURL:self.url];
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request
{
    if (self = [super init]) {
        _allowNewIfBusy = NO;
        self.url = (request) ? request.URL : nil;
        _request = request;
    }
    return self;
}

- (void)setRequest:(NSURLRequest *)request {
    self.url = (request) ? request.URL : nil;
    _request = request;
}


/*
 * Start/Stop functionality
 * ============================ */
#pragma mark - Start/Stop functionality
+ (void)sendTrustedRequest:(NSURLRequest *)request finishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock {
    [self sendTrustedRequest:request
               finishedBlock:finishBlock
                        fail:failedBlock
                    progress:nil];
}

+ (void)sendTrustedRequest:(NSURLRequest *)request finishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock progress:(DTWebServiceProgressBlock)progressBlock {
    DTWebService *webService = [DTWebService webServiceWithRequest:request];
    if (request)
        webService.trustedHosts = @[request.URL.host];
    [webService startWithFinishedBlock:finishBlock fail:failedBlock progress:progressBlock];
}

+ (void)sendAsyncRequest:(NSURLRequest *)request finishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock {
    [self sendAsyncRequest:request finishedBlock:finishBlock fail:failedBlock progress:nil];
}

+ (void)sendAsyncRequest:(NSURLRequest *)request finishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock progress:(DTWebServiceProgressBlock)progressBlock {
    DTWebService *webService = [DTWebService webServiceWithRequest:request];
    [webService startWithFinishedBlock:finishBlock fail:failedBlock progress:progressBlock];
}


+ (void)sendAsyncRequest:(NSURLRequest *)request trustedHosts:(NSArray *)trustedHosts finishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock progress:(DTWebServiceProgressBlock)progressBlock {
    DTWebService *webService = [DTWebService webServiceWithRequest:request];
    if (trustedHosts)
        webService.trustedHosts  = [NSArray arrayWithArray:trustedHosts];
    [webService startWithFinishedBlock:finishBlock fail:failedBlock progress:progressBlock];
}


- (void)startWithFinishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock {
    [self startWithResponseBlock:nil finishedBlock:finishBlock fail:failedBlock progress:nil];
}

- (void)startWithFinishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock progress:(DTWebServiceProgressBlock)progressBlock {
    [self startWithResponseBlock:nil finishedBlock:finishBlock fail:failedBlock progress:progressBlock];
}

- (void)startWithResponseBlock:(DTWebServiceResponseBlock)responseBlock finishedBlock:(DTWebServiceFinishedBlock)finishBlock fail:(DTWebServiceFailedBlock)failedBlock progress:(DTWebServiceProgressBlock)progressBlock {
    self.responseBlock = responseBlock;
    self.finishedBlock = finishBlock;
    self.failedBlock = failedBlock;
    self.progressBlock = progressBlock;
    
    [self start];
}

- (void)start {
    if (_connection && _allowNewIfBusy)
        [self stop];
    else if (_connection && !_allowNewIfBusy)
        return;
    
    if (!_request) {
        if (self.failedBlock) {
            NSError *error = [NSError errorWithDomain:@"com.DTWebService" code:1 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"You need to specify a request.", @"DTWebService: A request is not specified")}];
            self.failedBlock(error, NO);
        }
        return;
    }
    
    _busy = YES;
    
    _connection = [NSURLConnection connectionWithRequest:_request delegate:self];
    [_connection start];
}

- (void)stop {
    [_connection cancel];
    _connection = nil;
    
    _busy = NO;
    
    if (self.failedBlock)
        self.failedBlock(nil, YES);
}


#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.responseBlock)
        self.responseBlock(response);
    
    // every response could mean a redirect
    _receivedData = nil;
    _fileSize = [NSNumber numberWithLongLong:response.expectedContentLength];
    
    // need to record the received encoding
    if (response.textEncodingName) {
        // http://stackoverflow.com/questions/1409537/nsdata-to-nsstring-converstion-problem
        CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding( (CFStringRef)[response textEncodingName] );
        _encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
    } else {
        
        // if there is no text encoding, fall back to UTF8
        _encoding = NSUTF8StringEncoding;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_receivedData) {
        // no store yet, make one
        _receivedData = [[NSMutableData alloc] initWithData:data];
    }
    else{
        // append to previous chunks
        [_receivedData appendData:data];
    }
    
    
    NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:_receivedData.length];
    float progress = [resourceLength floatValue]/[_fileSize floatValue];
    if (self.progressBlock)
        self.progressBlock(progress * 100);
}

// all worked
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //	NSString *xml = [[NSString alloc] initWithData:_receivedData encoding:_encoding];
    //	NSLog(@"%@", xml);
    
    _connection = nil;
    _busy = NO;
    if (self.finishedBlock)
        self.finishedBlock(_receivedData, _encoding);
}

// and error occured
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //	NSLog(@"Error retrieving data, %@", [error localizedDescription]);
    _connection = nil;
    _busy = NO;
    if (self.failedBlock)
        self.failedBlock(error, NO);
}


// to deal with self-signed certificates
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // we only trust our own domain
        if ([self.trustedHosts containsObject:challenge.protectionSpace.host])
        {
            NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


@end





