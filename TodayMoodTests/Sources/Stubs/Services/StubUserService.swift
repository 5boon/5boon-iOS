//
//  StubUserService.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/03/15.
//

import RxSwift
import Stubber

@testable import TodayMood

final class StubUserService: UserServiceType {
    var currentUser: Observable<User?> {
        return .never()
    }
    
    func signup(userName: String, nickName: String, password: String) -> Observable<SignUpUser> {
        return Stubber.invoke(signup, args: (userName, nickName, password))
    }
    
    func me() -> Observable<User> {
        return Stubber.invoke(me, args: (), default: .never())
    }
}
