//
//  GroupFixture.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/05/15.
//

import Foundation
@testable import TodayMood

/*
 {
 "id" : 7,
 "is_reader" : true,
 "people" : [
 {
 "id" : 8,
 "name" : "kanz1"
 }
 ],
 "people_cnt" : 1,
 "mood_group" : {
 "code" : "c0c0b1e00f1c088134968e6b01f2cf96a96f62eeb3c34d082b3ff2925063ef92",
 "id" : 5,
 "created" : "2020-05-13T23:52:46",
 "title" : "칸즈와 아이들",
 "modified" : "2020-05-13T23:52:46",
 "summary" : "iOS 공부하는 집단"
 }
 }
 */
struct GroupFixture {
    static let kanzGroup1: PublicGroup = fixture([
        "id": 7,
        "mood_group": [
            "id": 5,
            "created": "2020-05-13T23:52:46",
            "modified": "2020-05-13T23:52:46",
            "title": "칸즈와 아이들",
            "summary": "iOS 공부하는 집단",
            "code": "asdfasdfasdfadsf"
        ],
//        "is_reader": true,
        "people": [
            [
                "id": 8,
                "name": "kanz1"
            ]
        ],
        "people_cnt": 1
    ])
    
    static let kanzGroup2: PublicGroup = fixture([
        "id": 7,
        "mood_group": [
            "id": 5,
            "created": "2020-05-13T23:52:46",
            "modified": "2020-05-13T23:52:46",
            "title": "칸즈와 아이들",
            "summary": "iOS 공부하는 집단",
            "code": "asdfasdfasdfadsf"
        ],
//        "is_reader": true,
        "people": [
            [
                "id": 8,
                "name": "kanz1"
            ]
        ],
        "people_cnt": 1
    ])
}

