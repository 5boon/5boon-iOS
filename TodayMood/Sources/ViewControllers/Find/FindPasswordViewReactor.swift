//
//  FindPasswordViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/28.
//

import ReactorKit
import RxCocoa
import RxSwift

class FindPasswordViewReactor: Reactor {
    
    enum Action {
        case find(String?, String?)
    }
    
    enum Mutation {
        case setFindResult(User?)
        case setLoading(Bool)
    }
    
    struct State {
        var findResult: User?
        var isLoading: Bool = false
    }
    
    private let userService: UserServiceType
    
    let initialState: State
    
    init(userService: UserServiceType) {
        self.userService = userService
        
        initialState = State()
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .find(let name, let email):
            
            guard let name = name, name.isNotEmpty,
                let email = email, email.isNotEmpty else { return .empty() }
            
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request: Observable<Mutation> = self.requestFindPassword(userName: name, email: email)
            
            return Observable.concat(startLoading, request, endLoading)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setFindResult(let user):
            state.findResult = user
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
    
    private func requestFindPassword(userName: String, email: String) -> Observable<Mutation> {
        return self.userService.findPassword(username: userName, email: email)
            .map { user -> Mutation in
                return .setFindResult(user)
        }
    }
}
