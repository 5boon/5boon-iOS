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
    func signup(id: String, password: String, email: String, userName: String) -> Observable<User>
    // 내정보
    func me() -> Observable<User>
    // 아이디 찾기
    func findID(username: String, email: String) -> Observable<User>
    // 비밀번호 찾기
    func findPassword(username: String, email: String) -> Observable<User>
    // 중복 여부 체크
    func checkDuplicateID(username: String?, email: String?) -> Observable<Void>
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
    func signup(id: String, password: String, email: String, userName: String) -> Observable<User> {
        return self.networking.rx.request(.signup(id: id,
                                               password: password,
                                               email: email,
                                               userName: userName))
            .debug()
            .filterSuccessfulStatusCodes()
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
                GlobalStates.shared.currentUser.accept(user)
            })
    }
    
    /// 아이디 찾기
    func findID(username: String, email: String) -> Observable<User> {
        return self.networking.rx.request(.findID(username: username, email: email))
            .debug()
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(User.self)
    }
    
    /// 비밀번호 찾기
    func findPassword(username: String, email: String) -> Observable<User> {
        return self.networking.rx.request(.findPassword(username: username, email: email))
            .debug()
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(User.self)
    }
    
    /// 중복 여부 체크
    func checkDuplicateID(username: String?, email: String?) -> Observable<Void> {
        return self.networking.rx.request(.checkDuplicateID(username: username, email: email))
            .debug()
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map { _ in Void() }
    }
}
