//
//  UserService.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import RxSwift

protocol UserServiceType {
    
    var currentUser: Observable<User?> { get }
    
    // 회원가입
    func signup(userName: String, nickName: String, password: String) -> Observable<User>
    // 내정보
    func me() -> Observable<User>
    // 아이디 찾기
    func findID(username: String, email: String) -> Observable<User>
    // 비밀번호 찾기
    func findPassword(username: String, email: String) -> Observable<User>
}

final class UserService: UserServiceType {
    private let networking: UserNetworking
    
    init(networking: UserNetworking) {
        self.networking = networking
    }
    
    private let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)
    
    /// 회원가입
    func signup(userName: String, nickName: String, password: String) -> Observable<User> {
        return self.networking.request(.signup(userName: userName,
                                               nickName: nickName,
                                               password: password))
            .debug()
            .asObservable()
            .map(User.self)
    }
    
    /// 내정보 조회
    func me() -> Observable<User> {
        return self.networking.request(.me)
            .debug()
            .asObservable()
            .map(User.self)
            .do(onNext: { [weak self] user in
                self?.userSubject.onNext(user)
            })
    }
    
    /// 아이디 찾기
    func findID(username: String, email: String) -> Observable<User> {
        return self.networking.request(.findID(username: username, email: email))
            .debug()
            .asObservable()
            .map(User.self)
    }
    
    /// 비밀번호 찾기
    func findPassword(username: String, email: String) -> Observable<User> {
        return self.networking.request(.findPassword(username: username, email: email))
            .debug()
            .asObservable()
            .map(User.self)
    }
}
