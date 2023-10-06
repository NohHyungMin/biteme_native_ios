source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

target 'bitemecokr' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for bitemecokr
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'BuzzBooster', '~> 2.0.6'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
               end
          end
   end
end
