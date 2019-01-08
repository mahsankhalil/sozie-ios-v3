platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!
use_frameworks!

target 'Sozie' do

pod 'TPKeyboardAvoiding'
pod 'SVProgressHUD'
pod 'SDWebImage', '~> 4.0'
pod 'DZNEmptyDataSet'
pod 'Google/SignIn'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'

pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'

pod 'SnapKit', '~> 4.0.0'
pod 'UnderLineTextField', '~> 2.1'
pod 'Alamofire'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
