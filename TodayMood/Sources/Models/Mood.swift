//
//  Mood.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import Foundation

/*
 {
   "id": 1451,
   "status": 15,
   "simple_summary": "2"
 }
 */
struct Mood: ModelType, Identifiable {
    let id: Int
    let moodStatus: MoodStatusTypes // 기분 점수
    let summary: String // 한줄 요약
    
    enum CodingKeys: String, CodingKey {
        case id
        case moodStatus = "status"
        case summary = "simple_summary"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let status = try container.decode(Int.self, forKey: .moodStatus)
        moodStatus = MoodStatusTypes(rawValue: status) ?? .soso
        summary = try container.decode(String.self, forKey: .summary)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(moodStatus.rawValue, forKey: .moodStatus)
        try container.encode(summary, forKey: .summary)
    }
}
