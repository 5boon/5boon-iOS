//
//  SplashViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import ReactorKit
import RxCocoa
import RxSwift

class SplashViewReactor: Reactor {
    
    enum Action {
        case checkIfAuthenticated
    }
    
    enum Mutation {
        case setAuthenticated(Bool)
    }
    
    struct State {
        var isAuthenticated: Bool?
    }
    
    let initialState = State()
    
    private let userService: UserServiceType
    private let authService: AuthServiceType
    
    init(userService: UserServiceType, authService: AuthServiceType) {
        self.userService = userService
        self.authService = authService
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkIfAuthenticated:
            guard self.authService.currentAccessToken?.accessToken != nil else {
                return Observable.just(.setAuthenticated(false))
            }
            
            return self.userService.me()
                .map { _ in true }
                .catchErrorJustReturn(false)
                .map(Mutation.setAuthenticated)   
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setAuthenticated(let isAuthenticated):
            state.isAuthenticated = isAuthenticated
        }
        return state
    }
}
