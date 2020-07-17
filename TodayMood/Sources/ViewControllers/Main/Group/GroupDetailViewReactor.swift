//
//  GroupDetailViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/18.
//

import ReactorKit
import RxCocoa
import RxSwift

class GroupDetailViewReactor: Reactor {
    
    enum Action {
        case firstLoad
    }
    
    enum Mutation {
        case setGroupMemberMoods([GroupMemberMood])
        case setLoading(Bool)
    }
    
    struct State {
        var groupInfo: PublicGroup
        var groupID: Int {
            return groupInfo.id
        }
        var groupMembers: [GroupUser] {
            return groupInfo.groupMembers
        }
        var groupMemberMoods: [GroupMemberMood] = []
        
        var isLoading: Bool = false
        var sections: [GroupDetailMoodSection] {
            let sectionItems: [GroupDetailMoodSectionItem] = groupMemberMoods.map {
                GroupDetailMoodCellReactor(mood: $0)
            }.map(GroupDetailMoodSectionItem.groupMood)
            return [.groupMood(sectionItems)]
        }
    }
    
    let initialState: State
    
    let groupService: GroupServiceType
    
    init(groupService: GroupServiceType, groupInfo: PublicGroup) {
        self.groupService = groupService
        initialState = State(groupInfo: groupInfo)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .firstLoad:
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request = self.requestGroupDetail()
            return Observable.concat(startLoading, request, endLoading)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setGroupMemberMoods(let memberMoods):
            state.groupMemberMoods = memberMoods
        }
        return state
    }
    
    private func requestGroupDetail() -> Observable<Mutation> {
        return self.groupService.groupDetail(groupID: self.currentState.groupID, displayMine: true)
            .map { moods -> Mutation in
                let filtered = moods.filter({ mood -> Bool in
                    return mood.mood != nil
                })
                return .setGroupMemberMoods(filtered)
        }.catchErrorJustReturn(.setGroupMemberMoods([]))
    }
}
