//
//  GroupAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/09.
//

import Moya

enum GroupAPI {
    case groupList
}

extension GroupAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .groupList:
            return "/groups/mine/"
        }
    }
    
    var method: Method {
        switch self {
        case .groupList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .groupList:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
