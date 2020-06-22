//
//  PublicGroupCellReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/10.
//

import ReactorKit
import RxCocoa
import RxSwift

class PublicGroupCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var group: PublicGroup
        var user: User?
    }
    
    let initialState: State
    
    init(group: PublicGroup) {
        initialState = State(group: group,
                             user: GlobalStates.shared.currentUser.value)
    }
}
