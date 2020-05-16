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
        case setID(String?)
        case setPassword(String?)
    }
    
    enum Mutation {
        case setLoggedIn(Bool)
        case setLoading(Bool)
        case setID(String?)
        case setPassword(String?)
    }
    
    struct State {
        var isLoggedIn: Bool = false
        var isLoading: Bool = false
        var isLoginValidate: Bool = false
        var userID: String?
        var password: String?
    }
    
    let initialState = State()
    
    private let authService: AuthServiceType
    private let userService: UserServiceType
    private let groupService: GroupServiceType
    
    init(authService: AuthServiceType,
         userService: UserServiceType,
         groupService: GroupServiceType) {
        self.authService = authService
        self.userService = userService
        self.groupService = groupService
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
                .flatMap { _ in self.fetchGroupList() }
                .map { _ in true }
                .catchErrorJustReturn(false)
                .map(Mutation.setLoggedIn)
            return Observable.concat(startLoading, request, endLoading)
            
        case .setID(let email):
            return Observable.just(.setID(email))
            
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
            
        case .setID(let userID):
            state.userID = userID
            let password = self.currentState.password
            state.isLoginValidate = String.validateID(userID) && String.validatePassword(password)
            
        case .setPassword(let password):
            state.password = password
            let userID = self.currentState.userID
            state.isLoginValidate = String.validateID(userID) && String.validatePassword(password)
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
        guard let userID = self.currentState.userID else { return false }
        guard let password = self.currentState.password else { return false }
        return userID.isNotEmpty && password.isNotEmpty
    }
    
    private func fetchGroupList() -> Observable<[PublicGroup]> {
        return self.groupService.groupList()
    }
}
