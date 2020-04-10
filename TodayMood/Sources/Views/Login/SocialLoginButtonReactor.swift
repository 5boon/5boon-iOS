//
//  SocialLoginButtonReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/27.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class SocialLoginButtonReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var type: SocialLoginTypes
        var isShowUnderLine: Bool
    }
    
    var initialState: State
    
    init(type: SocialLoginTypes, isShowUnderLine: Bool = true) {
        initialState = State(type: type,
                             isShowUnderLine: isShowUnderLine)
    }
}
