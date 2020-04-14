//
//  UserAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import Moya

enum UserAPI {
    // 회원가입
    case signup(id: String, password: String, email: String, userName: String)
    // 내 정보
    case me
    
    // ID 찾기
    case findID(username: String, email: String)
    // Password 찾기
    case findPassword(username: String, email: String)
    // 중복 체크
    case checkDuplicateID(username: String?, email: String?)
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
        case .findID:
            return "/users/id/"
        case .findPassword:
            return "/users/password/"
        case .checkDuplicateID:
            return "/users/check/"
        }
    }
    
    var method: Method {
        switch self {
        case .signup:
            return .post
        case .me:
            return .get
        case .findID:
            return .post
        case .findPassword:
            return .post
        case .checkDuplicateID:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .signup(let id, let password, let email, let userName):
            let params: [String: Any] = [
                "username": id,
                "password": password,
                "email": email,
                "name": userName
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .me:
            return .requestPlain
            
        case .findID(let username, let email):
            let params: [String: Any] = [
                "name": username,
                "email": email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .findPassword(username: let username, email: let email):
            let params: [String: Any] = [
                "username": username,
                "email": email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .checkDuplicateID(let username, let email):
            var params: [String: Any] = [:]
            if let userName = username {
                params["username"] = userName
            }
            if let email = email {
                params["email"] = email
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
 
