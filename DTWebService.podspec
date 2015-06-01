Pod::Spec.new do |s|
  s.name     = 'DTWebService'
  s.version  = '1.0'
  s.platform = :ios, '5.0'
  s.summary  = 'A wrapper to make HttpRequests with the ability to ignore invalid SSL certificates and a NSURLRequest category that supports custom headers and files.'
  s.description = 'This is a wrapper to make HttpRequests and a NSURLRequest category that supports custom headers and files. Among other things, the web service, has the ability to ignore invalid SSL certificates (by setting trusted hosts). It also using blocks to track a successful's request response data, failure or the progress percentage of the request. Demo project included.'
  s.homepage = 'https://github.com/dtsolis/DTWebService'
  s.author   = { 'Dimitris - Sotiris Tsolis' => 'dimitristls@gmail.com' }
  s.source   = { :git => 'https://github.com/dtsolis/DTWebService.git', :tag => '1.0' }
  s.license      = { :type => 'Apache', :file => 'LICENSE.md' }
  s.source_files = 'DTWebService/*.{h,m}'
  s.requires_arc = true
end
