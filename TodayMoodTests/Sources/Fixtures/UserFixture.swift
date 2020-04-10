//
//  UserFixture.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/03/15.
//

import Foundation
@testable import TodayMood

struct UserFixture {
    static let kanz: User = fixture([
        "id": 8,
        "date_joined": "2020-03-10T10:30:35.031034Z",
        "nickname": "kanz1",
        "username": "kanz1",
        "email": "kanz@5boon.me"
    ])
}
