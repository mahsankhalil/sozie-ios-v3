platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

def all_pods
pod 'TPKeyboardAvoiding'
pod 'SVProgressHUD'
pod 'SDWebImage', '~> 4.0'
pod 'GoogleSignIn'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
pod 'Alamofire'
pod 'MaterialTextField', '~> 1.0'
pod 'EasyTipView', '~> 2.0.0'
pod 'SideMenu'
pod 'Hex'
pod 'WaterfallLayout', '~> 0.1'
pod 'CCBottomRefreshControl'
pod 'SwiftLint'
pod 'Firebase/Analytics'
#pod 'Appsee', '~> 2.5.1'
#pod 'Intercom'
pod 'DLRadioButton', '~> 1.4'
end
target 'Sozie' do
    all_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
