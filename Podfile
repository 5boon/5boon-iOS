platform :ios, '13.0'
inhibit_all_warnings!

def firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics' 
  pod 'Firebase/Performance'
end

def app_pods
  # Architecture
  pod 'ReactorKit'
  
  # Networking
  pod 'Alamofire'
  pod 'Moya'
  pod 'Moya/RxSwift', '~> 14.0'
  
  # Image Cache
  pod 'Kingfisher'
  
  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxViewController'
  pod 'RxOptional'
  pod 'RxKeyboard'
  
  # UI
  pod 'SnapKit'
  pod 'EMTNeumorphicView'
  pod 'UITextView+Placeholder'
  
  
  # Logger
  pod 'SwiftyBeaver'
  
  # Lint
  pod 'SwiftLint'
  
  # etc
  pod 'Then'
  pod 'ReusableKit'
  pod 'AcknowList'
  pod 'URLNavigator'
  pod 'Immutable'
  pod 'Bagel', '~>  1.3.2'
  pod 'SideMenu', '~> 6.0'
  
  # DI
  pod 'Pure'
  
  # Keychain
  pod 'KeychainAccess'
  
  # SNS
  # pod 'FBSDKLoginKit'
  
end


def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Stubber'
    pod 'Immutable'
end


target 'TodayMood' do
  use_frameworks!
  
  app_pods
  firebase
  
  # Testing
  target "TodayMoodTests" do
    inherit! :search_paths
    testing_pods
  end
  
end
