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
        
        case moveNext
        case movePrev
    }
    
    enum Mutation {
        case setMoods([Mood], next: String?)
        case appendMoods([Mood], next: String?)
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setNext(String?)
        case createdMoodInsert(Mood)
        
        case setCurrentDate(Date)
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
        var today: Date
        var currentDate: Date
    }
    
    let initialState: State
    
    private let moodService: MoodServiceType
    let homeGradientViewReactor: HomeGradientViewReactor
    let homeTimeLineHeaderViewReactor: TimeLineHeaderViewReactor
    
    init(moodService: MoodServiceType) {
        let today = Date.startOfToday()
        self.moodService = moodService
        self.homeGradientViewReactor = HomeGradientViewReactor(currentDate: today)
        self.homeTimeLineHeaderViewReactor = TimeLineHeaderViewReactor(currentDate: today)
        initialState = State(moods: [],
                             today: today,
                             currentDate: today)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard self.currentState.isRefreshing == false else { return .empty() }
            let startRefreshing: Observable<Mutation> = Observable.just(.setRefreshing(true))
            let endRefresing: Observable<Mutation> = Observable.just(.setRefreshing(false))
            let clearPaging: Observable<Mutation> = self.clearPaging()
            let moodsRequest: Observable<Mutation> = self.requestMoods(date: self.currentState.currentDate)
            return Observable.concat(clearPaging, startRefreshing, moodsRequest, endRefresing)
            
        case .firstLoad:
            guard self.currentState.isRefreshing == false else { return .empty() }
            guard self.currentState.isLoading == false else { return .empty() }
            let startLoading: Observable<Mutation> = Observable.just(.setLoading(true))
            let endLoading: Observable<Mutation> = Observable.just(.setLoading(false))
            let moodsRequest: Observable<Mutation> = self.requestMoods(date: self.currentState.currentDate)
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
            
        case .movePrev:
            let prevDay = self.currentState.currentDate.add(.day, value: -1) ?? Date()
            let prev: Observable<Mutation> = Observable.just(.setCurrentDate(prevDay))
            let moodsRequest: Observable<Mutation> = self.requestMoods(date: prevDay)
            
            self.homeGradientViewReactor.action.onNext(.updateDate(prevDay))
            self.homeTimeLineHeaderViewReactor.action.onNext(.update(prevDay))
            
            return Observable.concat(prev, moodsRequest)
            
        case .moveNext:
            let nextDay = self.currentState.currentDate.add(.day, value: 1) ?? Date()
            let next: Observable<Mutation> = Observable.just(.setCurrentDate(nextDay))
            let moodsRequest: Observable<Mutation> = self.requestMoods(date: nextDay)
            
            self.homeGradientViewReactor.action.onNext(.updateDate(nextDay))
            self.homeTimeLineHeaderViewReactor.action.onNext(.update(nextDay))
            
            return Observable.concat(next, moodsRequest)
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
        case .setCurrentDate(let date):
            state.currentDate = date
        }
        return state
    }
    
    private func clearPaging() -> Observable<Mutation> {
        return Observable.just(.setNext(nil))
    }
    
    private func requestMoods(date: Date) -> Observable<Mutation> {
        return self.moodService.moodList(date: date.string(dateFormat: Constants.DateFormats.moodsQueryFormat))
            .map { list -> Mutation in
                self.homeGradientViewReactor.action.onNext(.updateMood(list.results.first))
                return .setMoods(list.results, next: list.next)
        }.catchErrorJustReturn(.setMoods([], next: nil))
    }
    
    private func requestMoreMoods(next: String?) -> Observable<Mutation> {
        let date = self.currentState.currentDate
        return self.moodService.moodList(date: date.string(dateFormat: Constants.DateFormats.moodsQueryFormat),
                                         page: next)
            .map { list -> Mutation in
                return .appendMoods(list.results, next: list.next)
        }.catchErrorJustReturn(.appendMoods([], next: nil))
    }
}
