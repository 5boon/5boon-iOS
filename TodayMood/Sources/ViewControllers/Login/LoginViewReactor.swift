//
//  LoginViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import ReactorKit
import RxCocoa
import RxSwift

class LoginViewReactor: Reactor {
    
    enum Action {
        case login(userName: String?, password: String?)
        case setEmail(String?)
        case setPassword(String?)
    }
    
    enum Mutation {
        case setLoggedIn(Bool)
        case setLoading(Bool)
        case setEmail(String?)
        case setPassword(String?)
    }
    
    struct State {
        var isLoggedIn: Bool = false
        var isLoading: Bool = false
        var isLoginValidate: Bool = false
        var email: String?
        var password: String?
    }
    
    let initialState = State()
    
    private let authService: AuthServiceType
    private let userService: UserServiceType
    
    init(authService: AuthServiceType,
         userService: UserServiceType) {
        self.authService = authService
        self.userService = userService
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login(let userName, let password):
            guard let userName = userName, let password = password else { return .empty() }
            guard userName.isNotEmpty, password.isNotEmpty else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request: Observable<Mutation> = self.login(userName: userName, password: password)
                .flatMap { _ in self.fetchMeInfo() }
                .map { _ in true }
                .catchErrorJustReturn(false)
                .map(Mutation.setLoggedIn)
            return Observable.concat(startLoading, request, endLoading)
            
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
        case .setLoggedIn(let isLoggedIn):
            state.isLoggedIn = isLoggedIn
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setEmail(let email):
            state.email = email
            let password = self.currentState.password
            state.isLoginValidate = String.validateEmail(email) && String.validatePassword(password)
            
        case .setPassword(let password):
            state.password = password
            let email = self.currentState.email
            state.isLoginValidate = String.validateEmail(email) && String.validatePassword(password)
        }
        return state
    }
    
    private func login(userName: String, password: String) -> Observable<Void> {
        return self.authService.requestToken(userName: userName, password: password)
    }
    
    private func fetchMeInfo() -> Observable<User> {
        return self.userService.me()
    }
    
    private func validationCheck() -> Bool {
        guard let email = self.currentState.email else { return false }
        guard let password = self.currentState.password else { return false }
        return email.isNotEmpty && password.isNotEmpty
    }
}
