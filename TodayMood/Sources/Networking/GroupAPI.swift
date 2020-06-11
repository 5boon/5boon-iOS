//
//  GroupAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/09.
//

import Moya

enum GroupAPI {
    case groupList
    case createGroup(title: String, summary: String)
}

extension GroupAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .groupList:
            return "/groups/mine/"
        case .createGroup:
            return "/groups/"
        }
    }
    
    var method: Method {
        switch self {
        case .groupList:
            return .get
        case .createGroup:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .groupList:
            return .requestPlain
        case .createGroup(let title, let summary):
            let params: [String: Any] = [
                "title": title,
                "summary": summary
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
