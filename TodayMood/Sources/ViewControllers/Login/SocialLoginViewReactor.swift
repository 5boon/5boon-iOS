//
//  SocialLoginViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import ReactorKit
import RxCocoa
import RxSwift

class SocialLoginViewReactor: Reactor {
    
    enum Action {
        case login(SocialLoginTypes)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setUser(User)
    }
    
    struct State {
        var isLoading: Bool = false
        var loggedInUser: User?
    }
    
    let initialState = State()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
//        switch <#value#> {
//        case <#pattern#>:
//            <#code#>
//        }
        return .empty()
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
//        switch mutation {
//        case <#pattern#>:
//            <#code#>
//        }
        return state
    }
}
