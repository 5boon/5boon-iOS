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
        case setLoading(Bool)
        case setFindResult(User?)
        case setFailedText(String?)
    }
    
    struct State {
        var isLoading: Bool = false
        var findResult: User?
        var failedText: String?
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
        case .setFailedText(let failedText):
            state.failedText = failedText
        }
        return state
    }
    
    private func requestFindPassword(userName: String, email: String) -> Observable<Mutation> {
        return self.userService.findPassword(username: userName, email: email)
            .map { user -> Mutation in
                return .setFindResult(user)
        }.catchError { error -> Observable<Mutation> in
            logger.error(error)
            let failedText: Observable<Mutation> = Observable.just(.setFailedText("일치되는 사용자가 없습니다."))
            return failedText
        }
    }
}
