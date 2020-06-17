platform :ios, '13.0'
inhibit_all_warnings!


def is_pod_binary_cache_enabled
  ENV['IS_POD_BINARY_CACHE_ENABLED'] == 'true'
end

if is_pod_binary_cache_enabled
  plugin 'cocoapods-binary-cache'
  # set_custom_xcodebuild_options_for_prebuilt_frameworks :simulator => "DEBUG_INFORMATION_FORMAT=dwarf", :device => "ARCHS=arm64 DEBUG_INFORMATION_FORMAT=dwarf"
  # TODO: BUILD_LIBRARY_FOR_DISTRIBUTION is to build with library evolution, but it doesn't work in Xcode 10.2 now, need find another way
  # set_custom_xcodebuild_options_for_prebuilt_frameworks :simulator => "BUILD_LIBRARY_FOR_DISTRIBUTION=YES", :device => "ARCHS=arm64 BUILD_LIBRARY_FOR_DISTRIBUTION=YES"
  set_is_prebuild_job(true)
  enable_devpod_prebuild
  
end

def binary_pod(name, *args)
  if is_pod_binary_cache_enabled
    pod name, args, :binary => true
  else
    pod name, args
  end
end

def firebase
  binary_pod 'Firebase/Analytics'
  binary_pod 'Firebase/Crashlytics' 
  binary_pod 'Firebase/Performance'
end

def app_pods
  # Architecture
  binary_pod 'ReactorKit'
  
  # Networking
  binary_pod 'Alamofire'
  binary_pod 'Moya'
  binary_pod 'Moya/RxSwift', '~> 14.0'
  
  # Image Cache
  binary_pod 'Kingfisher'
  
  # Rx
  binary_pod 'RxSwift'
  binary_pod 'RxCocoa'
  binary_pod 'RxDataSources'
  binary_pod 'RxGesture'
  binary_pod 'RxViewController'
  binary_pod 'RxOptional'
  binary_pod 'RxKeyboard'
  
  # UI
  binary_pod 'SnapKit'
  binary_pod 'EMTNeumorphicView'
  binary_pod 'UITextView+Placeholder'
  
  
  # Logger
  binary_pod 'SwiftyBeaver'
  
  # Lint
  binary_pod 'SwiftLint'
  
  # etc
  binary_pod 'Then'
  binary_pod 'ReusableKit'
  binary_pod 'AcknowList'
  binary_pod 'URLNavigator'
  binary_pod 'Immutable'
  binary_pod 'Bagel', '~>  1.3.2'
  
  # DI
  binary_pod 'Pure'
  
  # Keychain
  binary_pod 'KeychainAccess'
  
  # SNS
  # pod 'FBSDKLoginKit'
  
end


def testing_pods
    binary_pod 'Quick'
    binary_pod 'Nimble'
    binary_pod 'RxTest'
    binary_pod 'RxBlocking'
    binary_pod 'Stubber'
    binary_pod 'Immutable'
end

# plugin 'cocoapods-rome', {:pre_compile => Proc.new { |installer|
# installer.pods_project.targets.each do |target|
#     target.build_configurations.each do |config|
#       config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
#       config.build_settings['ENABLE_BITCODE'] = 'YES'
#       config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
#     end
# end

#     dsym: false,
#     configuration: 'Release'
# }


target 'TodayMood' do
  use_frameworks!
  
  app_pods
  firebase
  
  # Testing
  target "TodayMoodTests" do
    inherit! :search_paths
    testing_pods
  end
  current_target_definition.swift_version = '4.2'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES' # Only work from Xcode 11
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
