//
//  UserAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import Moya

enum UserAPI {
    // 회원가입
    case signup(userName: String, nickName: String, password: String)
    // 내 정보
    case me
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/users/register/"
        case .me:
            return "/me/"
        }
    }
    
    var method: Method {
        switch self {
        case .signup:
            return .post
        case .me:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .signup(let userName, let nickName, let password):
            let params: [String: Any] = [
                "username": userName,
                "nickname": nickName,
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .me:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
 
