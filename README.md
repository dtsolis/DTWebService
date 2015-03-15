# DTWebService
This is a wrapper to make HttpRequests and a NSURLRequest category that supports custom headers and files. Among other things, the web service, has the ability to ignore invalid SSL certificates (by setting trusted hosts). 
It also using blocks to track a successful's request response data, failure or the progress percentage of the request. 

## Install
- Old fashioned way of copy-paste the `DTWebService` folder into your project

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


## License

Copyright 2015 © Dimitris-Sotiris Tsolis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
