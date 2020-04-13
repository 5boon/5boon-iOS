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
    
    func signup(id: String, password: String, email: String, userName: String) -> Observable<User> {
        return Stubber.invoke(signup, args: (id, password, email, userName))
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
    
    func checkDuplicateID(username: String?, email: String?) -> Observable<Void> {
        return Stubber.invoke(checkDuplicateID, args: (username, email))
    }
}
