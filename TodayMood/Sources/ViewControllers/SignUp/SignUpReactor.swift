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
        case checkDuplicateID
        
        case setEmail(String?)
        case checkDuplicateEmail
        
        case setName(String?)
        
        case signUp
    }
    
    enum Mutation {
        case setID(String?)
        case setPassword(String?)
        case setEmail(String?)
        case setName(String?)
        
        case setLoading(Bool)
        
        case setDuplicateID(Bool)
        case setDuplicateEmail(Bool)
        
        case signupFinished(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        
        var isValidateFirstStepField: Bool = false
        var isDuplicateID: Bool?
        
        var isValidateSecondStepField: Bool = false
        var isDuplicatedEmail: Bool?
        
        var isValidateThirdStepField: Bool = false
        
        var id: String?
        var password: String?
        var email: String?
        var name: String?
        
        var signupFinished: Bool = false
    }

    private let userService: UserServiceType
    private let authService: AuthServiceType
    
    var initialState: State
    
    init(userService: UserServiceType,
         authService: AuthServiceType) {
        self.userService = userService
        self.authService = authService
        
        initialState = State()
    }

    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setID(let id):
            return Observable.just(.setID(id))
        case .setPassword(let password):
            return Observable.just(.setPassword(password))
        case .setEmail(let email):
            return Observable.just(.setEmail(email))
        case .setName(let name):
            return Observable.just(.setName(name))
            
        case .checkDuplicateID:
            guard self.currentState.isLoading == false else { return .empty() }
            guard let id = self.currentState.id, id.isNotEmpty else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request = self.checkDuplicate(username: id)
            return Observable.concat(startLoading, request, endLoading)
            
        case .checkDuplicateEmail:
            guard self.currentState.isLoading == false else { return .empty() }
            guard let email = self.currentState.email, email.isNotEmpty else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request = self.checkDuplicate(email: email)
            return Observable.concat(startLoading, request, endLoading)
            
        case .signUp:
            guard self.currentState.isLoading == false else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request = self.signup()
            return Observable.concat(startLoading, request, endLoading)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setID(let id):
            state.id = id
            let password = state.password
            state.isValidateFirstStepField = self.checkFirstValidate(id: id, password: password)
        case .setPassword(let password):
            state.password = password
            let id = state.id
            state.isValidateFirstStepField = self.checkFirstValidate(id: id, password: password)
        case .setEmail(let email):
            state.email = email
            state.isValidateSecondStepField = self.checkSecondValidate(email: email)
        case .setName(let name):
            state.name = name
            state.isValidateThirdStepField = self.checkThirdValidate(name: name)
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setDuplicateID(let isDuplicateID):
            state.isDuplicateID = isDuplicateID
        case .setDuplicateEmail(let isDuplicatedEmail):
            state.isDuplicatedEmail = isDuplicatedEmail
        case .signupFinished(let signupFinished):
            state.signupFinished = signupFinished
        }
        return state
    }
    
    private func checkDuplicate(username: String? = nil, email: String? = nil) -> Observable<Mutation> {
        return self.userService.checkDuplicateID(username: username, email: email)
            .map { _ -> Mutation in
                if username != nil {
                    return .setDuplicateID(true)
                } else {
                    return .setDuplicateEmail(true)
                }
        }.catchError { error -> Observable<Mutation> in
            logger.error(error.localizedDescription)
            if username != nil {
                return Observable.just(.setDuplicateID(false))
            } else {
                return Observable.just(.setDuplicateEmail(false))
            }
        }
    }
    
    private func signup() -> Observable<Mutation> {
        guard let id = self.currentState.id,
            let password = self.currentState.password,
            let email = self.currentState.email,
            let name = self.currentState.name else { return .empty() }
        return self.userService.signup(id: id,
                                       password: password,
                                       email: email,
                                       userName: name)
            .flatMap { _ in self.authService.requestToken(userName: id, password: password) }
            .flatMap { _ in self.userService.me() }
            .map { _ in .signupFinished(true) }
            .catchErrorJustReturn(.signupFinished(false))
    }
    
    // MARK: Validation
    private func checkFirstValidate(id: String?, password: String?) -> Bool {
        return String.validateID(id) && String.validatePassword(password)
    }
    
    private func checkSecondValidate(email: String?) -> Bool {
        return String.validateEmail(email)
    }
    
    private func checkThirdValidate(name: String?) -> Bool {
        return String.validateNickName(name)
    }
}
