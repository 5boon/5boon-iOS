//
//  MoodAPI.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/19.
//

import Moya

enum MoodAPI {
    /// 기분 생성
    case createMood(status: Int, simpleSummary: String, groupList: [Int])
}

extension MoodAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createMood:
            return "/moods/"
        }
    }
    
    var method: Method {
        switch self {
        case .createMood:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .createMood(let status, let simpleSummary, let groupList):
            let params: [String: Any] = [
                "status": status,
                "simple_summary": simpleSummary,
                "group_list": groupList
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
