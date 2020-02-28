platform :ios, '12.0'
inhibit_all_warnings!

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
  pod 'RxViewController'
  pod 'RxOptional'
  pod 'RxKeyboard'
  
  # UI
  pod 'SnapKit'
  
  # Logger
  pod 'SwiftyBeaver'
  
  # Lint
  pod 'SwiftLint'
  
  # etc
  pod 'Then'
  pod 'ReusableKit'
  pod 'AcknowList'
end


def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
    pod 'RxBlocking'
end


target 'TodayMood' do
  use_frameworks!
  
  app_pods
  
  # Testing
  target "TodayMoodTests" do
    inherit! :search_paths
    testing_pods
  end
  
end
