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
        case leaveGroup
    }
    
    enum Mutation {
        case setGroupMemberMoods([GroupMemberMood])
        case setLoading(Bool)
        case setLeaveFinished(Bool?)
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
        var isLeaveFinished: Bool? = nil
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
        case .leaveGroup:
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let groupID = self.currentState.groupInfo.id
            let request = self.requestGroupLeave(groupID: groupID)
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
        case .setLeaveFinished(let isLeaveFinished):
            state.isLeaveFinished = isLeaveFinished
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
    
    private func requestGroupLeave(groupID: Int) -> Observable<Mutation> {
        return self.groupService.leaveGroup(groupID: groupID)
            .map { _ -> Mutation in
                return .setLeaveFinished(true)
            }.catchErrorJustReturn(.setLeaveFinished(nil))
    }
}
