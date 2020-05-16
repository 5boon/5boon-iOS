//
//  GroupFixture.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/05/15.
//

import Foundation
@testable import TodayMood

struct GroupFixture {
    static let kanzGroup1: PublicGroup = fixture([
        "id": 7,
        "user": 8,
        "mood_group": [
          "id": 5,
          "created": "2020-05-13T23:52:46",
          "modified": "2020-05-13T23:52:46",
          "title": "칸즈와 아이들",
          "summary": "iOS 공부하는 집단"
        ],
        "is_reader": true
    ])
    
    static let kanzGroup2: PublicGroup = fixture([
        "id": 9,
        "user": 8,
        "mood_group": [
          "id": 7,
          "created": "2020-05-14T18:23:48",
          "modified": "2020-05-14T18:23:48",
          "title": "제이의",
          "summary": "hoxy 하는 집단"
        ],
        "is_reader": true
    ])
}

