platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!
$static_framework = ['Segment-Intercom']
def all_pods
pod 'TPKeyboardAvoiding'
pod 'SVProgressHUD'
pod 'SDWebImage', '~> 4.4.2'
pod 'GoogleSignIn'
pod 'FBSDKCoreKit', '~> 4.39.1'
pod 'FBSDKLoginKit', '~> 4.39.1'
pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
pod 'Alamofire', '~> 4.8.0'
pod 'MaterialTextField', '~> 1.0'
pod 'EasyTipView', '~> 2.0.1'
pod 'SideMenu', '~> 5.0.3'
pod 'Hex', '~> 6.0.0'
pod 'WaterfallLayout', '~> 0.1'
pod 'CCBottomRefreshControl'
pod 'SwiftLint', '0.30.0'
#pod 'Firebase/Analytics'
#pod 'Appsee', '~> 2.5.1'
pod 'Intercom'
pod 'DLRadioButton', '~> 1.4'
pod 'Fabric', '~> 1.10.2'
pod 'Crashlytics', '~> 3.13.4'
pod 'Analytics', '~> 3.6.10'
#pod 'Segment-Intercom', '1.0.0-beta'
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


