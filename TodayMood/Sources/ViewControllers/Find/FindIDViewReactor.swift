//
//  FindIDViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/28.
//

import ReactorKit
import RxCocoa
import RxSwift

class FindIDViewReactor: Reactor {
    
    enum Action {
        case find(String, String)
    }
    
    enum Mutation {
        case setFindResult(User?)
    }
    
    struct State {
        var findResult: User?
    }
    
    let initialState = State()
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .find(let name, let email):
            logger.debug("name: \(name), email: \(email)")
            let testUser = User(id: 0,
                                userName: "오채리",
                                nickName: "도로시",
                                email: "dorosi@kakao.com",
                                joinDate: "2020-05-05")
            return Observable.just(.setFindResult(testUser))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setFindResult(let user):
            state.findResult = user
        }
        return state
    }
}
