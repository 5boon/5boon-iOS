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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
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
