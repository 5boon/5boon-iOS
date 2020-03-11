//
//  AccessToken.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/09.
//

struct AccessToken: ModelType {
    var accessToken: String
    var tokenType: String
    var scope: String
    var refreshToken: String
    
    init(accessToken: String, tokenType: String, scope: String, refreshToken: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
        self.refreshToken = refreshToken
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case refreshToken = "refresh_token"
    }
}
