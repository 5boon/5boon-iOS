//
//  Constants.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import Foundation

struct Constants {
    
    struct OAuth {
        static var basicCredentials: String {
            return String.base64Credentials
        }
    }
    
    /// 키체인 고유 키
    struct KeychainKeys {
        static let serviceName = "com.5boon.TodayMood"
        static let accessToken = "access_token"
        static let tokenType = "token_type"
        static let refreshToken = "refresh_token"
        static let expired = "expired"
    }
    
    /// URL 
    struct URLs {
        @BundleInfoWrapper(key: "BaseURL")
        static var base: String
        
        static var baseURL: String {
            return URLs.base.replacingOccurrences(of: "\\", with: "")
        }
    }
    
    /// UserDefaultKey
    struct UserDefaultKeys {
        static let firstLaunch = "firstLaunch"
    }
    
    /// DateFormat
    struct DateFormats {
        static let serverFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        static let moodsQueryFormat = "yyyy-MM-dd" // 기분 조회시
    }
}
