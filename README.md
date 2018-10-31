# DTWebService

![Platforms][platforms-svg]

[![Podspec][podspec-svg]][podspec-link]

This is a wrapper to make HttpRequests and a NSURLRequest category that supports custom headers and files. Among other things, the web service, has the ability to ignore invalid SSL certificates (by setting trusted hosts). 
It also using blocks to track a successful's request response data, failure or the progress percentage of the request. 

## Install
- Old fashioned way of copy-paste the `DTWebService` folder into your project
- Using [CocoaPods](http://cocoapods.org/). Add `pod 'DTWebService'` to Podfile.

## Example usage
Example 1: Make a simple request (changing the `sendAsyncRequest:` to `sendTrustedRequest:` will ignore any invalid SSL certificate)
<pre>
[DTWebService sendAsyncRequest:request finishedBlock:^(NSData *data, NSStringEncoding stringEncoding) {
    // handle completion
} fail:^(NSError *error, BOOL cancelled) {
    // handle failure
} progress:^(float progressPercentage) {
    // handle progress (update ui etc.)
}];
</pre>

Example 2: Make a cancelable request
<pre>
DTWebService *webService = [[DTWebService alloc] initWithURL:[NSURL URLWithString:@"a url..."]];
[webService startWithFinishedBlock:^(NSData *data, NSStringEncoding stringEncoding) {
    
} fail:^(NSError *error, BOOL cancelled) {
    
} progress:^(float progressPercentage) {
    
}];

....

[webService stop]; // stop/cancel the request
</pre>

[podspec-svg]: https://img.shields.io/cocoapods/v/DTWebService.svg
[podspec-link]: https://cocoapods.org/pods/DTWebService
[platforms-svg]: https://img.shields.io/cocoapods/p/DTWebService.svg?style=flat

## License

Apache licensed, as found in the [LICENSE.md](LICENSE.md) file.
