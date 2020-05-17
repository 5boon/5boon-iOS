//
//  MoodService.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/19.
//

import RxSwift

protocol MoodServiceType {
    /// 기분 생성
    func createMood(status: Int, simpleSummary: String, groupList: [Int]) -> Observable<Mood>
    /// 기분 조회
    func moodList(date: String?, page: String?) -> Observable<List<Mood>>
}

extension MoodServiceType {
    func moodList(date: String? = nil, page: String? = nil) -> Observable<List<Mood>> {
        return moodList(date: date, page: page)
    }
}

final class MoodService: MoodServiceType {
    
    private let networking: MoodNetworking
    
    init(networking: MoodNetworking) {
        self.networking = networking
    }
    
    func createMood(status: Int, simpleSummary: String, groupList: [Int]) -> Observable<Mood> {
        return self.networking.request(.createMood(status: status, simpleSummary: simpleSummary, groupList: groupList))
            .debug()
            .asObservable()
            .map(Mood.self)
    }
    
    func moodList(date: String? = nil, page: String? = nil) -> Observable<List<Mood>> {
        return self.networking.request(.moodList(date: date, page: page))
            .debug()
            .asObservable()
            .map(List<Mood>.self)
    }
}
