//
//  GroupMemberMood.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/23.
//

import Foundation

struct GroupMemberMood: ModelType {
    let userName: String
    var mood: Mood? // 기분이 등록되지 않은 경우, null
    
    enum CodingKeys: String, CodingKey {
        case userName = "user"
        case mood
    }
}
