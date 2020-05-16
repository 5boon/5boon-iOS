//
//  MoodWriteGroupListViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/11.
//

import ReactorKit
import RxCocoa
import RxSwift

class MoodWriteGroupListViewReactor: Reactor {
    
    enum Action {
        case selectGroup(PublicGroup)
    }
    
    enum Mutation {
        case selectGroup(PublicGroup)
        case deselectGroup(PublicGroup)
    }
    
    struct State {
        var groups: [PublicGroup]
        var sections: [MoodWriteGroupSection] {
            let sectionItems: [MoodWriteGroupSectionItem] = groups.map { group -> MoodWriteGroupListCellReactor in
                let isSelected = selectedGroups.contains(where: { $0.id == group.id })
                return MoodWriteGroupListCellReactor(group: group,
                                                     isSelected: isSelected)
            }.map(MoodWriteGroupSectionItem.group)
            return [.group(sectionItems)]
        }
        var selectedGroups: [PublicGroup]
    }
    
    let initialState: State
    
    init(selectedGroups: [PublicGroup]) {
        initialState = State(groups: GlobalStates.shared.groups.value,
                             selectedGroups: selectedGroups)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectGroup(let group):
            if currentState.selectedGroups.contains(where: { $0.id == group.id }) {
                return Observable.just(.deselectGroup(group))
            } else {
                return Observable.just(.selectGroup(group))
            }
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .selectGroup(let group):
            state.selectedGroups.append(group)
        case .deselectGroup(let group):
            state.selectedGroups.removeAll(where: { $0.id == group.id })
        }
        return state
    }
    
}
