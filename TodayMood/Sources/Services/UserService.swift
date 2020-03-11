//
//  UserService.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import RxSwift

protocol UserServiceType {
    func signup(userName: String, nickName: String, password: String) -> Observable<SignUpUser>
    
    func me() -> Observable<User>
}

final class UserService: UserServiceType {
    
    private let networking: UserNetworking
    
    init(networking: UserNetworking) {
        self.networking = networking
    }
    
    /// 회원가입
    func signup(userName: String, nickName: String, password: String) -> Observable<SignUpUser> {
        return self.networking.request(.signup(userName: userName,
                                               nickName: nickName,
                                               password: password))
            .debug()
            .asObservable()
            .map(SignUpUser.self)
    }
    
    /// 내정보 조회
    func me() -> Observable<User> {
        return self.networking.request(.me)
            .debug()
            .asObservable()
            .map(User.self)
    }
}
