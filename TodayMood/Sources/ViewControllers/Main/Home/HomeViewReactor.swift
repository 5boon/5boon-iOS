//
//  HomeViewReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomeViewReactor: Reactor {
    
    enum Action {
        case firstLoad
        case refresh
        case loadMore
        case createdMoodInsert(Mood)
    }
    
    enum Mutation {
        case setMoods([Mood], next: String?)
        case appendMoods([Mood], next: String?)
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setNext(String?)
        case createdMoodInsert(Mood)
    }
    
    struct State {
        var isLoading: Bool = false
        var isRefreshing: Bool = false
        var moods: [Mood]
        var sections: [TimeLineSection] {
            let sectionItems: [TimeLineSectionItem] = moods.map { mood -> HomeTimeLineCellReactor in
                HomeTimeLineCellReactor(mood: mood)
            }.map(TimeLineSectionItem.timeLine)
            return [.timeLine(sectionItems)]
        }
        var next: String?
        var date: Date? // 2020-03-14
    }
    
    let initialState: State
    
    private let moodService: MoodServiceType
    
    init(moodService: MoodServiceType) {
        self.moodService = moodService
        initialState = State(moods: [])
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            let startRefreshing: Observable<Mutation> = Observable.just(.setRefreshing(true))
            let endRefresing: Observable<Mutation> = Observable.just(.setRefreshing(false))
            let clearPaging: Observable<Mutation> = self.clearPaging()
            let moodsRequest: Observable<Mutation> = self.requestMoods()
            return Observable.concat(clearPaging, startRefreshing, moodsRequest, endRefresing)
            
        case .firstLoad:
            guard self.currentState.isRefreshing == false else { return .empty() }
            guard self.currentState.isLoading == false else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let moodsRequest: Observable<Mutation> = self.requestMoods()
            return Observable.concat(startLoading, moodsRequest, endLoading)
            
        case .loadMore:
            guard self.currentState.isRefreshing == false else { return .empty() }
            guard self.currentState.isLoading == false else { return .empty() }
            guard let next = self.currentState.next else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let draftMoreRequest: Observable<Mutation> = self.requestMoreMoods(next: next)
            return Observable.concat(startLoading, draftMoreRequest, endLoading)
            
        case .createdMoodInsert(let mood):
            return Observable.just(.createdMoodInsert(mood))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        case .setMoods(let moods, let next):
            state.moods = moods
            state.next = next
        case .appendMoods(let moods, let next):
            let newMoods = state.moods + moods
            state.moods = newMoods
            state.next = next
        case .setNext(let next):
            state.next = next
        case .createdMoodInsert(let mood):
            var moods = state.moods
            moods.insert(mood, at: 0)
            state.moods = moods
        }
        return state
    }
    
    private func clearPaging() -> Observable<Mutation> {
        return Observable.just(.setNext(nil))
    }
    
    private func requestMoods() -> Observable<Mutation> {
        let date = self.currentState.date
        return self.moodService.moodList(date: date?.string(dateFormat: Constants.DateFormats.moodsQueryFormat))
            .map { list -> Mutation in
                return .setMoods(list.results, next: list.next)
        }.catchErrorJustReturn(.setMoods([], next: nil))
    }
    
    private func requestMoreMoods(next: String?) -> Observable<Mutation> {
        let date = self.currentState.date
        return self.moodService.moodList(date: date?.string(dateFormat: Constants.DateFormats.moodsQueryFormat),
                                         page: next)
            .map { list -> Mutation in
                return .appendMoods(list.results, next: list.next)
        }.catchErrorJustReturn(.appendMoods([], next: nil))
    }
}
