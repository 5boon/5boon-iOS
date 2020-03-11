//
//  Constants.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import Foundation

struct Constants {
    
    /// 키체인 고유 키
    struct KeychainKeys {
        static let serviceName = "com.5boon.TodayMood"
        static let accessToken = "access_token"
        static let tokenType = "token_type"
        static let scope = "scope"
        static let refreshToken = "refresh_token"
    }
    
    /// OAuth 키
    struct OAuthKeys {
        @BundleInfoWrapper(key: "ClientID")
        static var clientID: String
        
        @BundleInfoWrapper(key: "ClientSecret")
        static var clientSecret: String
    }
    
    /// URL 
    struct URLs {
        @BundleInfoWrapper(key: "BaseURL")
        static var baseURL: String
    }
}
