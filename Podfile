platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Sozie' do

pod 'AFNetworking', '~> 3.0'
pod 'TPKeyboardAvoiding'
pod 'SVProgressHUD'
pod 'SDWebImage', '~> 4.0'
pod 'DZNEmptyDataSet'
pod 'Google/SignIn'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
