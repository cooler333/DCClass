Pod::Spec.new do |s|
  s.name        = 'DCClass'
  s.version     = '0.0.5'
  s.license     = 'MIT'
  s.summary     = 'iOS App Helper.'
  s.homepage    = 'https://github.com/cooler333/DCClass'
  s.social_media_url = 'https://twitter.com/Cooler333'
  s.author       = { 'Dmitry Coolerov' => 'utm4@mail.ru' }
  s.source       = { :git => 'https://github.com/cooler333/DCClass.git', :tag => s.version, :submodules => true }
  s.requires_arc = true
  
  s.ios.deployment_target = '7.0'

  s.public_header_files = 'DCClass/*.h', 'DCClass/DCLog.h', 'DCClass/KeychainWrapper/KeychainWrapper.h'
  s.source_files = 'DCClass/DCClass.h', 'DCClass/DCLog.h'

  s.subspec 'APIManager' do |ss|
    ss.source_files = 'DCClass/DCAPIManager.{h,m}', 'DCClass/DCLog.h'
    ss.dependency   'AFNetworking', '2.5.1' 
  end

  s.subspec 'Color' do |ss|
    ss.source_files     = 'DCClass/DCColor.{h,m}'
    ss.ios.frameworks   = 'UIKit'
  end

  s.subspec 'NavigationController' do |ss|
    ss.source_files     = 'DCClass/DCNavigationController.{h,m}'
    ss.ios.frameworks   = 'UIKit'
  end

  s.subspec 'SideMenuViewController' do |ss|
    ss.dependency 'DCClass/ViewController'

    ss.source_files     = 'DCClass/DCSideMenuViewController.{h,m}'
    ss.ios.frameworks   = 'UIKit'
  end

  s.subspec 'TableViewCell' do |ss|
    ss.source_files     = 'DCClass/DCTableViewCell.{h,m}'
    ss.ios.frameworks   = 'UIKit'
  end

  s.subspec 'ViewController' do |ss|
    ss.dependency 'DCClass/Color'
    
    ss.source_files     = 'DCClass/DCViewController.{h,m}'
    ss.ios.frameworks   = 'UIKit'
  end

  s.subspec 'KeychainWrapper' do |ss|
    ss.source_files         = 'DCClass/DCKeychainWrapper.{h,m}', 'DCClass/KeychainWrapper/KeychainWrapper.{h,m}'
    ss.ios.frameworks       = 'Security', 'Foundation'
  end

end