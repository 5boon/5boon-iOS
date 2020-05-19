//
//  SettingsViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import ReactorKit
import RxCocoa
import RxSwift

class SettingsViewReactor: Reactor {
    
    enum Action {
        case logout
    }
    
    enum Mutation {
        case setLogoutFinished(Bool?)
    }
    
    struct State {
        var isLoggedOut: Bool?
    }
    
    let initialState: State
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
        initialState = State()
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .logout:
            authService.logout()
            return Observable.just(.setLogoutFinished(true))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLogoutFinished(let finished):
            state.isLoggedOut = finished
        }
        return state
    }
}
