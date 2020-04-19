//
//  MoodService.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/19.
//

import RxSwift

protocol MoodServiceType {
    /// 기분 생성
    func createMood(status: Int, simpleSummary: String, groupList: [Int]) -> Observable<Void>
}

final class MoodService: MoodServiceType {
    
    private let networking: MoodNetworking
    
    init(networking: MoodNetworking) {
        self.networking = networking
    }
    
    func createMood(status: Int, simpleSummary: String, groupList: [Int]) -> Observable<Void> {
        return self.networking.request(.createMood(status: status, simpleSummary: simpleSummary, groupList: groupList))
            .debug()
            .asObservable()
            .map { _ in Void() }
    }
}
