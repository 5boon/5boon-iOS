//
//  GroupDetailMoodCellReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/07/12.
//

import ReactorKit
import RxCocoa
import RxSwift

class GroupDetailMoodCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var mood: GroupMemberMood
    }
    
    let initialState: State
    
    init(mood: GroupMemberMood) {
        initialState = State(mood: mood)
    }
}
