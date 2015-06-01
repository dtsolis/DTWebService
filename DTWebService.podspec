Pod::Spec.new do |s|
  s.name     = 'DTWebService'
  s.version  = '1.0'
  s.platform = :ios, '5.0'
  s.summary  = 'Wrapper for HttpRequest(s) with ability to ignore SSL certificates & a NSURLRequest category for custom headers and files.'
  s.description = 'Wrapper for HttpRequest(s) with ability to ignore SSL certificates & a NSURLRequest category for custom headers and files. Includes demo.'
  s.homepage = 'https://github.com/dtsolis/DTWebService'
  s.author   = { 'Dimitris - Sotiris Tsolis' => 'dimitristls@gmail.com' }
  s.source   = { :git => 'https://github.com/dtsolis/DTWebService.git', :tag => '1.0' }
  s.license      = { :type => 'Apache', :file => 'LICENSE.md' }
  s.source_files = 'DTWebService/*.{h,m}'
  s.requires_arc = true
end