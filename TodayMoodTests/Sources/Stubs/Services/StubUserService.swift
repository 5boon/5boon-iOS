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
    
    func signup(userName: String, nickName: String, password: String) -> Observable<User> {
        return Stubber.invoke(signup, args: (userName, nickName, password))
    }
    
    func me() -> Observable<User> {
        return Stubber.invoke(me, args: (), default: .never())
    }
    
    func findID(username: String, email: String) -> Observable<User> {
        return Stubber.invoke(findID, args: (username, email))
    }
    
    func findPassword(username: String, email: String) -> Observable<User> {
        return Stubber.invoke(findPassword, args: (username, email))
    }
}
