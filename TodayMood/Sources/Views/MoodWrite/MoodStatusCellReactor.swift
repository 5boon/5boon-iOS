//
//  MoodStatusCellReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/20.
//

import ReactorKit
import RxCocoa
import RxSwift

class MoodStatusCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var status: MoodStatusTypes
        var isSelected: Bool
    }
    
    let initialState: State
    
    init(status: MoodStatusTypes, isSelected: Bool) {
        self.initialState = State(status: status, isSelected: isSelected)
    }
}
