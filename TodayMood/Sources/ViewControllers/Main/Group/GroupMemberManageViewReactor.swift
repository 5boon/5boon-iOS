//
//  GroupMemberManageViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/23.
//

import ReactorKit
import RxCocoa
import RxSwift

class GroupMemberManageViewReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var groupMembers: [GroupUser]
        var sections: [GroupMemberManageSection] {
            let sectionItems: [GroupMemberManageSectionItem] = groupMembers.map {
                GroupMemberManageCellReactor(user: $0)
            }.map(GroupMemberManageSectionItem.memberList)
            
            return [.memberList(sectionItems)]
        }
    }
    
    let initialState: State
    
    init(groupMembers: [GroupUser]) {
        initialState = State(groupMembers: groupMembers)
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
