Pod::Spec.new do |s|
  s.name        = 'DCClass'
  s.version     = '0.0.21'
  s.license     = 'MIT'
  s.summary     = 'iOS App Helper.'
  s.homepage    = 'https://github.com/cooler333/DCClass'
  s.social_media_url = 'https://twitter.com/Cooler333'
  s.author       = { 'Dmitry Coolerov' => 'utm4@mail.ru' }
  s.source       = { :git => 'https://github.com/cooler333/DCClass.git', :tag => s.version, :submodules => true }
  s.requires_arc = true
  
  s.ios.deployment_target = '7.0'

  s.public_header_files = 'DCClass/*.h'
  s.source_files = 'DCClass/DCClass.h'

  s.subspec 'Log' do |ss|
    ss.ios.frameworks = 'Foundation'

    ss.source_files = 'DCClass/DCLog.h'
  end

  s.subspec 'CheckDevice' do |ss|
    ss.ios.frameworks = 'Foundation'

    ss.source_files = 'DCClass/DCCheckDevice.h'
  end

  s.subspec 'APIManager' do |ss|
    ss.dependency 'AFNetworking', '~> 2.0' 
    ss.dependency 'DCClass/Log'

    ss.source_files = 'DCClass/DCAPIManager.{h,m}'
  end

  s.subspec 'Color' do |ss|
    ss.ios.frameworks   = 'UIKit'

    ss.source_files     = 'DCClass/DCColor.{h,m}'
  end

  s.subspec 'NavigationController' do |ss|
    ss.ios.frameworks   = 'UIKit'
   
    ss.source_files     = 'DCClass/DCNavigationController.{h,m}'
  end

  s.subspec 'SideMenuViewController' do |ss|
    ss.ios.frameworks   = 'UIKit'
    ss.dependency 'DCClass/ViewController'
    ss.dependency 'DCClass/DCBundleHelper'
   
    ss.source_files     = 'DCClass/DCSideMenuViewController.{h,m}'
  end

  s.subspec 'DCBundleHelper' do |ss|
    ss.ios.frameworks   = 'UIKit'
    ss.resource_bundle = {
      'ImageBundle' => [
        'DCClass/Resources/DCImages.xcassets',
        'DCClass/Resources/**/*.png',
        'DCClass/Resources/*.png'
      ]
    }
    ss.source_files     = 'DCClass/DCBundleHelper.{h,m}'
  end

  s.subspec 'TableViewCell' do |ss|
    ss.ios.frameworks   = 'UIKit'
   
    ss.source_files     = 'DCClass/DCTableViewCell.{h,m}'
  end

  s.subspec 'ViewController' do |ss|
    ss.ios.frameworks   = 'UIKit'
    ss.dependency 'DCClass/CheckDevice'
    
    ss.source_files     = 'DCClass/DCViewController.{h,m}'
  end

  s.subspec 'KeychainWrapper' do |ss|
    ss.ios.frameworks   = 'Security', 'Foundation'

    ss.public_header_files = 'DCClass/KeychainWrapper/KeychainWrapper.h'
    ss.source_files        = 'DCClass/DCKeychainWrapper.{h,m}', 'DCClass/KeychainWrapper/KeychainWrapper.{h,m}'
  end

end