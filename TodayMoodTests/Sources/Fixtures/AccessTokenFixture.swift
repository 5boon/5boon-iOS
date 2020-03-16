//
//  AccessTokenFixture.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/03/15.
//

import Foundation
@testable import TodayMood

struct AccessTokenFixture {
    static let token: AccessToken = fixture([
        "access_token": "87hSndIu7be5JhNPE2JlWQjgOkmLzY",
        "expires_in": 36000,
        "token_type": "Bearer",
        "scope": "read write",
        "refresh_token": "GeSBuiGfN8SQITON6PMHdFYyoSlsKm"
    ])
}
