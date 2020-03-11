//
//  URLNavigationMap.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/11.
//

import UIKit

import URLNavigator

// 참고: https://github.com/devxoul/URLNavigator/blob/master/Example/Sources/Navigator/NavigationMap.swift

final class URLNavigationMap {
    
    static func initialize(navigator: NavigatorType,
                           authService: AuthServiceType) {
        // navigator.register(<#T##pattern: URLPattern##URLPattern#>, <#T##factory: ViewControllerFactory##ViewControllerFactory##(URLConvertible, [String : Any], Any?) -> UIViewController?#>)
        // navigator.handle(<#T##pattern: URLPattern##URLPattern#>, <#T##factory: URLOpenHandlerFactory##URLOpenHandlerFactory##(URLConvertible, [String : Any], Any?) -> Bool#>)
    }
    
    /*
     private static func webViewControllerFactory(
       url: URLConvertible,
       values: [String: Any],
       context: Any?
     ) -> UIViewController? {
       guard let url = url.urlValue else { return nil }
       return SFSafariViewController(url: url)
     }

     private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
       return { url, values, context in
         guard let title = url.queryParameters["title"] else { return false }
         let message = url.queryParameters["message"]
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         navigator.present(alertController)
         return true
       }
     }
     */
}
