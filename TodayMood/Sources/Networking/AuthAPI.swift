//
//  AuthAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/16.
//

import Moya

enum AuthAPI {
    case requestToken(userName: String, password: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .requestToken:
            return "/o/token/"
        }
    }
    
    var method: Method {
        switch self {
        case .requestToken:
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
                "scope": "read write",
                "client_id": Secrets.clientID,
                "client_secret": Secrets.clientSecret,
                "grant_type": "password"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
}
