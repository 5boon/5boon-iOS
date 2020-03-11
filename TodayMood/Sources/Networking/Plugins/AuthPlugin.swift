//
//  AuthPlugin.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/11.
//

import Moya

struct AuthPlugin: PluginType {
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        if let accessToken = self.authService.currentAccessToken?.accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
