//
//  SignUpViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import ReactorKit
import RxCocoa
import RxSwift

class SignUpViewReactor: Reactor {
    
    enum Action {
        case setEmail(String?)
        case setPassword(String?)
    }
    
    enum Mutation {
        case setEmail(String?)
        case setPassword(String?)
    }
    
    struct State {
        var isValidate: Bool = false
        var email: String?
        var password: String?
    }
    
    let initialState = State()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setEmail(let email):
            return Observable.just(.setEmail(email))
            
        case .setPassword(let password):
            return Observable.just(.setPassword(password))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setEmail(let email):
            state.email = email
            let password = self.currentState.password
            state.isValidate = String.validateEmail(email) && String.validatePassword(password)
            
        case .setPassword(let password):
            state.password = password
            let email = self.currentState.email
            state.isValidate = String.validateEmail(email) && String.validatePassword(password)
        }
        return state
    }
}
