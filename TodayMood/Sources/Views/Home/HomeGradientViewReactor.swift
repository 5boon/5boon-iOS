//
//  HomeGradientViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomeGradientViewReactor: Reactor {
    
    enum Action {
        case updateDate(Date)
        case updateMood(Mood?)
    }
    
    enum Mutation {
        case setCurrentDate(Date)
        case setMood(Mood?)
    }
    
    struct State {
        var user: User?
        var isEnableMoveToPrev: Bool
        var isEnableMoveToNext: Bool
        var today: Date
        var currentDate: Date
        var latestMood: Mood?
    }
    
    let initialState: State
    
    init(currentDate: Date) {
        initialState = State(user: GlobalStates.shared.currentUser.value,
                             isEnableMoveToPrev: true,
                             isEnableMoveToNext: false,
                             today: Date.startOfToday(),
                             currentDate: currentDate,
                             latestMood: nil)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateDate(let date):
            return Observable.just(.setCurrentDate(date))
            
        case .updateMood(let mood):
            return Observable.just(.setMood(mood))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCurrentDate(let date):
            state.currentDate = date
        case .setMood(let mood):
            state.latestMood = mood
        }
        return state
    }
}
