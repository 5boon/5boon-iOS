//
//  AccessToken.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/09.
//

import Foundation

struct AccessToken: Decodable {
    var accessToken: String
    var tokenType: String
    var refreshToken: String
    var expiredAt: Date
    var expired: String // 키체인 저장을 위해 String으로 변환
    var isValid: Bool {
        return Date().compare(expiredAt) == .orderedAscending // 현재시간이 expired time보다 뒤면 만료됨
    }
    
    init(accessToken: String, tokenType: String, refreshToken: String, expired: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expired = expired
        self.expiredAt = expired.date(dateFormat: Constants.DateFormats.serverFormat) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        let expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        expiredAt = Date().add(.second, value: expiresIn) ?? Date().addingTimeInterval(TimeInterval(expiresIn))
        expired = expiredAt.string(dateFormat: Constants.DateFormats.serverFormat)
    }
}
