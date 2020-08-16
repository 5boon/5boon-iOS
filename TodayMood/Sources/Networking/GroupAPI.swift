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
    case joinGroup(groupCode: String)
    case groupDetail(groupID: Int, displayMine: Bool)
    case leaveGroup(groupID: Int)
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
        case .joinGroup:
            return "/groups/invitation/"
        case .groupDetail(let groupID, _):
            return "/groups/mine/\(groupID)/"
        case .leaveGroup(let groupID):
            return "/groups/mine/\(groupID)/"
        }
    }
    
    var method: Method {
        switch self {
        case .groupList:
            return .get
        case .createGroup:
            return .post
        case .joinGroup:
            return .post
        case .groupDetail:
            return .get
        case .leaveGroup:
            return .delete
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
        case .joinGroup(let groupCode):
            let params: [String: Any] = [
                "code": groupCode
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .groupDetail(_, let displayMine):
            var params: [String: Any] = [:]
            if displayMine == true {
                params["display_mine"] = "true"
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .leaveGroup:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
