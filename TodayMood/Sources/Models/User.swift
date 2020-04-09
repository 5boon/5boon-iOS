//
//  User.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/10.
//

import Foundation

/**
 {
 "id": 8,
 "date_joined": "2020-03-10T10:30:35.031034Z",
 "nickname": "kanz1",
 "username": "kanz1",
 "email": ""
 }
 */
struct User: ModelType, Identifiable {
    let id: Int?
    let userName: String?
    let nickName: String?
    let email: String?
    let joinDate: String?
    var joinedAt: Date? {
        return joinDate?.convertServerDate()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "username"
        case nickName = "nickname"
        case email
        case joinDate = "date_joined"
    }
}
