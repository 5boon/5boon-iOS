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
        case setGroupName(String?)
        case setSummary(String?)
        case createGroup
        case clearFinish
    }
    
    enum Mutation {
        case setGroupName(String?)
        case setSummary(String?)
        case setLoading(Bool)
        case setCreateGroupFinished(Bool?)
    }
    
    struct State {
        var isLoading: Bool = false
        var groupName: String?
        var summary: String?
        var groupNameValid: Bool = false
        var summaryValid: Bool = false
        var isValid: Bool {
            return groupNameValid && summaryValid
        }
        var createGroupFinished: Bool? = false
    }
    
    let initialState: State
    
    private let groupService: GroupServiceType
    
    // MARK: Initializing
    init(groupService: GroupServiceType) {
        self.groupService = groupService
        initialState = State()
    }
    
    // MARK: Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setGroupName(let groupName):
            return Observable.just(.setGroupName(groupName))
        case .setSummary(let summary):
            return Observable.just(.setSummary(summary))
        case .createGroup:
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request = self.requestCreateGroup()
            return Observable.concat(startLoading, request, endLoading)
        case .clearFinish:
            return Observable.just(.setCreateGroupFinished(nil))
        }
    }
    
    // MARK: Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setGroupName(let groupName):
            state.groupName = groupName
            state.groupNameValid = groupName?.trim().isNotEmpty ?? false
        case .setSummary(let summary):
            state.summary = summary
            state.summaryValid = summary?.trim().isNotEmpty ?? false
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setCreateGroupFinished(let finished):
            state.createGroupFinished = finished
        }
        return state
    }
    
    private func requestCreateGroup() -> Observable<Mutation> {
        guard let groupName = self.currentState.groupName, groupName.trim().isNotEmpty else { return .empty() }
        guard let summary = self.currentState.summary, summary.trim().isNotEmpty else { return .empty() }
        
        return self.groupService.createGroup(title: groupName, summary: summary)
            .map { _ -> Mutation in
                return .setCreateGroupFinished(true)
        }.catchErrorJustReturn(.setCreateGroupFinished(nil))
    }
}
