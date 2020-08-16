//
//  GroupMemberManageCellReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/07/11.
//

import ReactorKit
import RxCocoa
import RxSwift

class GroupMemberManageCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var user: GroupUser
    }
    
    let initialState: State
    
    init(user: GroupUser) {
        initialState = State(user: user)
    }
}
