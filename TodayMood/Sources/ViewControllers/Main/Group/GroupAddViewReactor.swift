//
//  GroupAddViewReactor.swift
//  TodayMood
//
//  Created Fernando on 2020/05/18.
//  Copyright © 2020 5boon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class GroupAddViewReactor: Reactor {
  
  enum Action {

  }
  
  enum Mutation {

  }
  
  struct State {

  }
  
  let initialState: State
  
  // MARK: Initializing  
  init() {
    initialState = State()
  }
  
  // MARK: Mutate
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
//    case .<#actionCase#>:
    }
  }
  
  // MARK: Reduce
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
//    case .<#mutationCase#>:
    }
  }
}
