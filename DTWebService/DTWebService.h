//
//  DTWebService.h
//
//  Created by Dimitris-Sotiris Tsolis on 1/9/14.
//  Copyright (c) 2014 Dimitris-Sotiris Tsolis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DTWebServiceResponseBlock)(NSURLResponse *response);
typedef void (^DTWebServiceFinishedBlock)(NSData *data, NSStringEncoding stringEncoding);
typedef void (^DTWebServiceFailedBlock)(NSError *error, BOOL cancelled);
typedef void (^DTWebServiceProgressBlock)(float progressPercentage);


@interface NSURLRequest (DTWebService_NSURLRequest)

/// Designated initializer to create an http request with custom headers
+ (NSURLRequest *)requestWithURL:(NSURL *)url httpHeaders:(NSDictionary *)headers;

/// Designated initializer to create an http request to upload a file
+ (NSURLRequest *)requestWithURL:(NSURL *)url file:(NSData *)fileData fileName:(NSString *)fileName;

/// Designated initializer to create an http request with custom headers and a file to upload
+ (NSURLRequest *)requestWithURL:(NSURL *)url httpHeaders:(NSDictionary *)headers file:(NSData *)fileData fileName:(NSString *)fileName;
@end



/*!
 This is a wrapper to make HttpRequests with the ability to ignore invalid SSL certificates (by setting trusted hosts). It also using blocks to track a successful's request response data, failure or the progress percentage of the request.
 */
@interface DTWebService : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *trustedHosts;

/// Indicates wether the connection is actively connected to a request or not.
@property (getter=isBusy, readonly) BOOL busy;

/// If YES, cancels any previous requests (if any) when a new request is about to start. Default is NO.
@property (nonatomic, assign) BOOL allowNewIfBusy;

@property (nonatomic, strong) DTWebServiceResponseBlock responseBlock;
@property (nonatomic, strong) DTWebServiceFinishedBlock finishedBlock;
@property (nonatomic, strong) DTWebServiceProgressBlock progressBlock;
@property (nonatomic, strong) DTWebServiceFailedBlock   failedBlock;


/// Returns a global DTWebService.
+ (instancetype)sharedInstance;
+ (instancetype)webServiceWithURL:(NSURL *)url;
+ (instancetype)webServiceWithRequest:(NSURLRequest *)request;
+ (instancetype)trustedWebServiceWithURL:(NSURL *)url;
+ (instancetype)trustedWebServiceWithRequest:(NSURLRequest *)request;
- (id)initWithURL:(NSURL *)url;
- (id)initWithRequest:(NSURLRequest *)request;
- (void)setRequest:(NSURLRequest *)request;



+ (void)sendTrustedRequest:(NSURLRequest *)request
             finishedBlock:(DTWebServiceFinishedBlock)finishBlock
                      fail:(DTWebServiceFailedBlock)failedBlock;

+ (void)sendTrustedRequest:(NSURLRequest *)request
             finishedBlock:(DTWebServiceFinishedBlock)finishBlock
                      fail:(DTWebServiceFailedBlock)failedBlock
                  progress:(DTWebServiceProgressBlock)progressBlock;

+ (void)sendAsyncRequest:(NSURLRequest *)request
           finishedBlock:(DTWebServiceFinishedBlock)finishBlock
                    fail:(DTWebServiceFailedBlock)failedBlock;

+ (void)sendAsyncRequest:(NSURLRequest *)request
           finishedBlock:(DTWebServiceFinishedBlock)finishBlock
                    fail:(DTWebServiceFailedBlock)failedBlock
                progress:(DTWebServiceProgressBlock)progressBlock;

+ (void)sendAsyncRequest:(NSURLRequest *)request
            trustedHosts:(NSArray *)trustedHosts
           finishedBlock:(DTWebServiceFinishedBlock)finishBlock
                    fail:(DTWebServiceFailedBlock)failedBlock
                progress:(DTWebServiceProgressBlock)progressBlock;

- (void)startWithFinishedBlock:(DTWebServiceFinishedBlock)finishBlock
                          fail:(DTWebServiceFailedBlock)failedBlock;

- (void)startWithFinishedBlock:(DTWebServiceFinishedBlock)finishBlock
                          fail:(DTWebServiceFailedBlock)failedBlock
                      progress:(DTWebServiceProgressBlock)progressBlock;

- (void)startWithResponseBlock:(DTWebServiceResponseBlock)responseBlock
                 finishedBlock:(DTWebServiceFinishedBlock)finishBlock
                          fail:(DTWebServiceFailedBlock)failedBlock
                      progress:(DTWebServiceProgressBlock)progressBlock;

- (void)start;
- (void)stop;

@end
