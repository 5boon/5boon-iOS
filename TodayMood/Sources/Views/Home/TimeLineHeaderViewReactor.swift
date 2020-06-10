//
//  TimeLineHeaderViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import ReactorKit
import RxCocoa
import RxSwift

class TimeLineHeaderViewReactor: Reactor {
    
    enum Action {
        case update(Date)
    }
    
    enum Mutation {
        case setCurrentDate(Date)
    }
    
    struct State {
        var currentDate: Date
    }
    
    let initialState: State
    
    init(currentDate: Date) {
        initialState = State(currentDate: currentDate)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update(let date):
            return Observable.just(.setCurrentDate(date))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCurrentDate(let date):
            state.currentDate = date
        }
        return state
    }
}
