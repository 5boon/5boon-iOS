//
//  PublicSettingViewReactor.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/21.
//

import ReactorKit
import RxCocoa
import RxSwift

class PublicSettingViewReactor: Reactor {
    
    enum Action {
        case selectType(MoodPublicSettingTypes)
    }
    
    enum Mutation {
        case setType(MoodPublicSettingTypes)
    }
    
    struct State {
        var publicType: MoodPublicSettingTypes = .private
    }
    
    let initialState = State()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectType(let type):
            return Observable.just(.setType(type))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setType(let type):
            state.publicType = type
        }
        return state
    }
}

