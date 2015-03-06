Pod::Spec.new do |spec|
  spec.name         = "DCClass"
  spec.version      = "0.0.1"
  spec.summary      = "iOS App Helper."
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/cooler333/DCClass'
  spec.author       = { "Dmitry Coolerov" => "utm4@mail.ru" }
  spec.summary      = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
  spec.source       = { :git => 'https://github.com/cooler333/DCClass.git', :tag => 'v0.0.1' }
  spec.public_header_files = 'DCClass/DCClass/*.h', 'DCClass/KeychainWrapper/KeychainWrapper.h' 
  spec.source_files = 'DCClass/DCClass/*.{h,m}', 'DCClass/KeychainWrapper/*.{h,m}'
  spec.platform     = :ios, "7.0"
  spec.framework    = 'UIKit', 'Foundation'
  spec.dependency     'AFNetworking', '~> 2.0'
end