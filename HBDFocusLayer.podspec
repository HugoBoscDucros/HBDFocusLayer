Pod::Spec.new do |s|
s.name             = 'HBDFocusLayer'
s.version          = '1.3.0'
s.summary          = 'HBDFocusLayer'

s.description      = 'Open source library. Focus Layer.'

s.homepage         = 'https://github.com/HugoBoscDucros/HBDFocusLayer.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Hugo Bosc Ducros' => 'hugo@padam.io' }
s.source           = { :git => 'https://github.com/HugoBoscDucros/HBDFocusLayer.git', :tag => s.version.to_s }
s.swift_version    = '5.0'

s.ios.deployment_target = '9.0'
s.source_files = ['Supporting files/*.{h,m,swift,xib}', 'Sources/HBDFoculLayer/*.{h,m,swift,xib}']

end
