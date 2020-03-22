//
//  NickNameViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/19.
//

import ReactorKit
import RxCocoa
import RxSwift

class NickNameViewReactor: Reactor {
    
    enum Action {
        case setNickName(String?)
        case signup
    }
    
    enum Mutation {
        case setNickName(String?)
        case setSigupFinished(Bool)
        case setIsLoading(Bool)
    }
    
    struct State {
        var isValidate: Bool = false
        var email: String
        var password: String
        var nickName: String?
        var isSignUpFinished: Bool = false
        var isLoading: Bool = false
    }
    
    let initialState: State
    
    private let userService: UserServiceType
    private let authService: AuthServiceType
    
    init(userService: UserServiceType, authService: AuthServiceType, email: String, password: String) {
        self.userService = userService
        self.authService = authService
        
        initialState = State(email: email, password: password)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setNickName(let nickName):
            return Observable.just(.setNickName(nickName))
            
        case .signup:
            let startLoading: Observable<Mutation> = Observable.just(.setIsLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setIsLoading(false))
            let request: Observable<Mutation> = self.requestSignUp()
            return Observable.concat(startLoading, request, endLoading)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNickName(let nickName):
            state.nickName = nickName
            state.isValidate = String.validateNickName(nickName)
            
        case .setIsLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setSigupFinished(let isFinished):
            state.isSignUpFinished = isFinished
        }
        return state
    }
    
    private func requestSignUp() -> Observable<Mutation> {
        guard let nickName = self.currentState.nickName else { return .empty() }
        let email = self.currentState.email
        let password = self.currentState.password
        
        return self.userService.signup(userName: nickName, nickName: nickName, password: password)
            .flatMap { _ in
                return self.authService.requestToken(userName: nickName, password: password)
        }.flatMap { _ in
            return self.userService.me()
        }.map { _ -> Mutation in
            return .setSigupFinished(true)
        }.catchErrorJustReturn(.setSigupFinished(false))
    }
}
