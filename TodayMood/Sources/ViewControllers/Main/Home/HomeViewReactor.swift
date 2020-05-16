//
//  HomeViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomeViewReactor: Reactor {
    
    enum Action {
        case firstLoad
    }
    
    enum Mutation {
        case setMoods([Mood])
    }
    
    struct State {
        var moods: [Mood]
    }
    
    let initialState: State
    
    private let moodService: MoodServiceType
    
    init(moodService: MoodServiceType) {
        self.moodService = moodService
        initialState = State(moods: [])
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .firstLoad:
            let request = self.requestMoods()
            return request
        }
        return .empty()
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setMoods(let moods):
            state.moods = moods
        }
        return state
    }
    
    private func requestMoods() -> Observable<Mutation> {
        return self.moodService.moodList()
            .map { list -> Mutation in
                return .setMoods(list.results)
        }
    }
}
