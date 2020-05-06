//
//  StubAuthService.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/03/15.
//

import RxSwift
import Stubber

@testable import TodayMood

final class StubAuthService: AuthServiceType {
    var currentAccessToken: AccessToken? {
        return AccessTokenFixture.token
    }
    
    func requestToken(userName: String, password: String) -> Observable<Void> {
        return Stubber.invoke(requestToken, args: (userName, password), default: .never())
    }
    
    func logout() {
        Stubber.invoke(logout, args: (), default: Void())
    }
    
    func refreshToken(token: String) -> Observable<String?> {
        return Stubber.invoke(refreshToken, args: (token))
    }
}
