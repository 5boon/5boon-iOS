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
    /// 기분 조회
    case moodList(date: String?, page: String?)
    
}

extension MoodAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .createMood:
            return "/moods/"
        case .moodList:
            return "/moods/"
        }
    }
    
    var method: Method {
        switch self {
        case .createMood:
            return .post
        case .moodList:
            return .get
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
            
        case .moodList(let date, let page):
            var param: [String: Any] = [:]
            if let date = date {
                param["date"] = date
            }
            
            if let page = page {
                param["cursor"] = page
            }
            
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
