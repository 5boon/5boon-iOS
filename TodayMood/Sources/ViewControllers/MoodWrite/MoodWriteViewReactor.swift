//
//  MoodWriteViewReactor.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/20.
//

import ReactorKit
import RxCocoa
import RxSwift

class MoodWriteViewReactor: Reactor {
    
    enum Action {
        case selectStatus(MoodStatusTypes)
        case setSummary(String?)
        case selectPublicSetting(MoodPublicSettingTypes, [PublicGroup])
        case sendCreateMood
    }
    
    enum Mutation {
        case setSelectedStatus(MoodStatusTypes)
        case setSummary(String?)
        case setUser(User)
        case setPublicSetting(MoodPublicSettingTypes, [PublicGroup])
        case setIsSendFinished(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var user: User?
        var writeDate: Date = Date()
        var statusSection: [MoodStatusSection] {
            let types = MoodStatusTypes.allCases
            let sectionItems = types.map { type -> MoodStatusSectionItem in
                MoodStatusSectionItem.status(MoodStatusCellReactor(status: type,
                                                                   isSelected: selectedStatus == type))
            }
            return [.status(sectionItems)]
        }
        
        var selectedStatus: MoodStatusTypes? // 기분 상태
        var summary: String? // 한줄
        var publicType: MoodPublicSettingTypes
        var selectedGroups: [PublicGroup]
        var isSendFinished: Bool?
        var isLoading: Bool = false
        var enableRequest: Bool = false
    }
    
    let initialState: State
    
    private let moodService: MoodServiceType
    let publicSettingViewReactor: PublicSettingViewReactor
    
    init(moodService: MoodServiceType) {
        self.moodService = moodService
        self.publicSettingViewReactor = PublicSettingViewReactor()
        self.initialState = State(user: GlobalStates.shared.currentUser.value,
                                  publicType: .private,
                                  selectedGroups: [])
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectStatus(let status):
            return Observable.just(.setSelectedStatus(status))
        case .setSummary(let summary):
            return Observable.just(.setSummary(summary))
        case .selectPublicSetting(let type, let groups):
            self.publicSettingViewReactor.action.onNext(.selectType(type))
            return Observable.just(.setPublicSetting(type, groups))
        case .sendCreateMood:
            guard self.currentState.isLoading == false else { return .empty() }
            
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let request = self.requestCreateMoode()
            
            return Observable.concat(startLoading, request, endLoading)
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setUser(let user):
            state.user = user
        case .setSelectedStatus(let selectedStatus):
            state.selectedStatus = selectedStatus
        case .setSummary(let summary):
            state.summary = summary
            state.enableRequest = (summary?.isEmpty == false)
        case .setPublicSetting(let type, let groups):
            state.publicType = type
            state.selectedGroups = groups
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setIsSendFinished(let isSendFinished):
            state.isSendFinished = isSendFinished
        }
        return state
    }
    
    //
    private func requestCreateMoode() -> Observable<Mutation> {
        guard let status = self.currentState.selectedStatus else { return .empty() }
        guard let summary = self.currentState.summary else { return .empty() }
        let groupList = self.currentState.selectedGroups.map { $0.moodGroup.id }
        
        return self.moodService.createMood(status: status.rawValue,
                                           simpleSummary: summary,
                                           groupList: groupList)
            .map { mood -> Mutation in
                NotificationCenter.default.post(name: .createMoodFinished, object: mood)
                return .setIsSendFinished(true)
        }.catchErrorJustReturn(.setIsSendFinished(false))
    }
}
