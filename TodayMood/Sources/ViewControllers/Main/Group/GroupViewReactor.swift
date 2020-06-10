//
//  GroupViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import ReactorKit
import RxCocoa
import RxSwift

class GroupViewReactor: Reactor {
    
    enum Action {
        case firstLoad
        case refresh
    }
    
    enum Mutation {
        case setGroups([PublicGroup])
        case setLoading(Bool)
        case setRefreshing(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        var groups: [PublicGroup]
        var sections: [PublicGroupSection] {
            let sectionItems: [PublicGroupSectionItem] = groups.map { group -> PublicGroupCellReactor in
                return PublicGroupCellReactor(group: group)
            }.map(PublicGroupSectionItem.groupList)
            
            return [.groupList(sectionItems)]
        }
    }
    
    let initialState: State
    
    let groupService: GroupServiceType
    
    init(groupService: GroupServiceType) {
        self.groupService = groupService
        initialState = State(groups: [])
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            let startRefreshing: Observable<Mutation> = Observable.just(.setRefreshing(true))
            let endRefresing: Observable<Mutation> = Observable.just(.setRefreshing(false))
            let groupsRequest: Observable<Mutation> = self.requestGroup()
            return Observable.concat(startRefreshing, groupsRequest, endRefresing)
            
        case .firstLoad:
            guard self.currentState.isRefreshing == false else { return .empty() }
            guard self.currentState.isLoading == false else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let groupsRequest: Observable<Mutation> = self.requestGroup()
            return Observable.concat(startLoading, groupsRequest, endLoading)
        }
        return .empty()
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        case .setGroups(let groups):
            state.groups = groups
        }
        return state
    }
    
    private func requestGroup() -> Observable<Mutation> {
        return self.groupService.groupList()
            .map { list -> Mutation in
                return .setGroups(list)
        }.catchErrorJustReturn(.setGroups([]))
    }
}
