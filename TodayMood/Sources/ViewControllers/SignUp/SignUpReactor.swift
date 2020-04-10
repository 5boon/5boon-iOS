//
//  SignUpReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/05.
//

import ReactorKit
import RxCocoa
import RxSwift

class SignUpReactor: Reactor {
    
    enum Action {
        case setID(String?)
        case setPassword(String?)
        case setEmail(String?)
        case setName(String?)
    }
    
    enum Mutation {
        case setID(String?)
        case setPassword(String?)
        case setEmail(String?)
        case setName(String?)
    }
    
    struct State {
        var isValidate: Bool = false
        var id: String?
        var password: String?
    }

    private let userService: UserServiceType
    
    var initialState: State
    
    init(userService: UserServiceType) {
        self.userService = userService
        
        initialState = State()
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
