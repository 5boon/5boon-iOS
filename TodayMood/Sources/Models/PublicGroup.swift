//
//  PublicGroup.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/25.
//

import Foundation

// 그룹리스트
struct PublicGroup: ModelType, Identifiable {
    let id: Int // 그룹 상세 조회용 ID
//    let isLeader: Bool // 그룹의 리더인지
    
    let moodGroup: MoodGroup // MoodGroup
    let groupMembers: [GroupUser]
    let groupMemberCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
//        case isLeader = "is_reader"
        case moodGroup = "mood_group"
        case groupMembers = "people"
        case groupMemberCount = "people_cnt"
    }
}

// 그룹의 정보
struct MoodGroup: ModelType, Identifiable {
    let id: Int
    let title: String
    let summary: String
    let created: String?
    var createdAt: Date? {
        created?.convertServerDate()
    }
    let modified: String?
    var modifiedAt: Date? {
        modified?.convertServerDate()
    }
    let groupCode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case created
        case modified
        case groupCode = "code"
    }
}

// 그룹 구성원
struct GroupUser: ModelType, Identifiable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
