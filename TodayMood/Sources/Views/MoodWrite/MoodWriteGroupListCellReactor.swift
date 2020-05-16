//
//  MoodWriteGroupListCellReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/11.
//

import ReactorKit
import RxCocoa
import RxSwift

class MoodWriteGroupListCellReactor: Reactor {
    
    enum Action { }
    
    enum Mutation { }
    
    struct State {
        var group: PublicGroup
        var isSelected: Bool
    }
    
    let initialState: State
    
    init(group: PublicGroup, isSelected: Bool) {
        initialState = State(group: group,
                             isSelected: isSelected)
    }
}
