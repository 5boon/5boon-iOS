//
//  PublicGroup.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/25.
//

import Foundation

struct PublicGroup: ModelType, Identifiable {
    let id: Int // 그룹 상세 조회용 ID
    let ownerID: Int // 그룹 생성한 User ID
    let isLeader: Bool // 그룹의 리더인지
    
    let moodGroup: MoodGroup // MoodGroup
    
    enum CodingKeys: String, CodingKey {
        case id
        case isLeader = "is_reader"
        case ownerID = "user"
        case moodGroup = "mood_group"
    }
    /*
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let moodGroup = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .moodGroup)
        
        id = try container.decode(Int.self, forKey: .id)
        ownerID = try container.decode(Int.self, forKey: .ownerID)
        isLeader = try container.decode(Bool.self, forKey: .isLeader)
        
        moodGroupID = try moodGroup.decode(Int.self, forKey: .moodGroupID)
        title = try moodGroup.decode(String.self, forKey: .title)
        summary = try moodGroup.decode(String.self, forKey: .summary)
        created = try moodGroup.decode(String.self, forKey: .created)
        modified = try moodGroup.decode(String.self, forKey: .modified)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var moodGroup = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .moodGroup)
        
        try container.encode(id, forKey: .id)
        try container.encode(ownerID, forKey: .ownerID)
        try container.encode(isLeader, forKey: .isLeader)
        
        try moodGroup.encode(moodGroupID, forKey: .moodGroupID)
        try moodGroup.encode(title, forKey: .title)
        try moodGroup.encode(summary, forKey: .summary)
        try moodGroup.encode(created, forKey: .created)
        try moodGroup.encode(modified, forKey: .modified)
    }
     */
}

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
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case created
        case modified
    }
}
