//
//  AuthAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/16.
//

import Moya

enum AuthAPI {
    case requestToken(userName: String, password: String)
    case refreshToken(refreshToken: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .requestToken:
            return "/o/token/"
        case .refreshToken:
            return "/o/token/"
        }
    }
    
    var method: Method {
        switch self {
        case .requestToken:
            return .post
        case .refreshToken:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .requestToken(let userName, let password):
            let params: [String: Any] = [
                "username": userName,
                "password": password,
                "grant_type": "password"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .refreshToken(let refreshToken):
            let params: [String: Any] = [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": Constants.OAuth.basicCredentials,
            "Content-Type": "application/x-www-form-urlencoded",
            "User-Agent": "5boon ios"
        ]
    }
}
