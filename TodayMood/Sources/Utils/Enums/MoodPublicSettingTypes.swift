//
//  MoodPublicSettingTypes.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/21.
//

import Foundation

enum MoodPublicSettingTypes: CaseIterable {
    case `private` // 나만 보기
    case group // 그룹 공개
    
    var iconImageName: String {
        switch self {
        case .private:
            return "publicsetting_private"
        case .group:
            return "publicsetting_group"
        }
    }
    
    var title: String {
        switch self {
        case .private:
            return "나만 보기"
        case .group:
            return "함께 보기"
        }
    }
}
