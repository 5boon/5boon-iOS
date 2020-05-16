//
//  MoodWritePublicSettingViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/21.
//

import ReactorKit
import RxCocoa
import RxSwift

class MoodWritePublicSettingViewReactor: Reactor {
    
    enum Action {
        case selectType(MoodPublicSettingTypes)
        case setSelectedGroups([PublicGroup])
    }
    
    enum Mutation {
        case setPublicType(MoodPublicSettingTypes)
        case setSelectedGroups([PublicGroup])
    }
    
    struct State {
        var publicType: MoodPublicSettingTypes
        var selectedGroups: [PublicGroup]
        var isEnable: Bool
    }
    
    let initialState: State
    
    init(publicType: MoodPublicSettingTypes = .private,
         selectedGroups: [PublicGroup]) {
        let isEnable = (publicType == .private) ? true : selectedGroups.isNotEmpty
        initialState = State(publicType: publicType,
                             selectedGroups: selectedGroups,
                             isEnable: isEnable)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectType(let type):
            return Observable.just(.setPublicType(type))
        case .setSelectedGroups(let groups):
            return Observable.just(.setSelectedGroups(groups))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPublicType(let type):
            state.publicType = type
            switch type {
            case .private:
                state.isEnable = true
                state.selectedGroups = []
            case .group:
                state.isEnable = state.selectedGroups.isNotEmpty
            }
        case .setSelectedGroups(let groups):
            state.selectedGroups = groups
            state.isEnable = true
        }
        return state
    }
}
