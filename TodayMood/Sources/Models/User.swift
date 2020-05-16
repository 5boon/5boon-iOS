//
//  User.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/10.
//

import Foundation

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
