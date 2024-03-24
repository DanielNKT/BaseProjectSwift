# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def pods_firebase
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'
  pod 'Firebase/Crashlytics'
end

def pods_rx
  pod 'RxSwift'
  pod 'RxCocoa'
end

def pods_support
  pod 'SwiftyBeaver'
  pod 'R.swift'
  pod 'SwifterSwift'
end

target 'BaseProjectSwift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pods_firebase
  pods_support
  pods_rx
  
  target 'BaseProjectSwiftTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'BaseProjectSwiftUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.2'
      end
    end
  end
end
