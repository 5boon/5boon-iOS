//
//  HomeTimeLineCellReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomeTimeLineCellReactor: Reactor {
    
    enum Action {
        // case <#case#>
    }
    
    enum Mutation {
        // case <#case#>
    }
    
    struct State {
        var mood: Mood
    }
    
    let initialState: State
    
    init(mood: Mood) {
        initialState = State(mood: mood)
    }
    
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
