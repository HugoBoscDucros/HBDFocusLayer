Pod::Spec.new do |s|
s.name             = 'HBDFocusLayer'
s.version          = '1.2.3'
s.summary          = 'HBDFocusLayer'

s.description      = 'Open source library. Focus Layer.'


s.homepage         = 'https://github.com/HugoBoscDucros/HBDFocusLayer.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Hugo Bosc Ducros' => 'hugo@padam.io' }
s.source           = { :git => 'https://github.com/HugoBoscDucros/HBDFocusLayer.git', :tag => s.version.to_s }
s.swift_version    = '4.2'

s.ios.deployment_target = '9.0'
s.source_files = 'FocusLayer/**/*.{h,m,swift,xib}'

end
