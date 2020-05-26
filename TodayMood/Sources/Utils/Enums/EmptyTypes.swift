//
//  EmptyTypes.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/26.
//

import Foundation

enum EmptyTypes {
    case homeMood // 홈화면 기분모곡
    
    var imageName: String {
        switch self {
        case .homeMood:
            return "timeline_empty"
        }
    }
    
    var message: String {
        switch self {
        case .homeMood:
            return "등록된 오늘의 기분이 없습니다."
        }
    }
}
