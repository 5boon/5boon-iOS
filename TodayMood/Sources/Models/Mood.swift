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
    let moodStatus: Int // 기분 점수
    let summary: String // 한줄 요약
    
    enum CodingKeys: String, CodingKey {
        case id
        case moodStatus = "status"
        case summary = "simple_summary"
    }
}
