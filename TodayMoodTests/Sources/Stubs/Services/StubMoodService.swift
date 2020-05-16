//
//  StubMoodService.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/19.
//

import RxSwift
import Stubber

@testable import TodayMood

final class StubMoodService: MoodServiceType {
    func createMood(status: Int, simpleSummary: String, groupList: [Int]) -> Observable<Void> {
        return Stubber.invoke(createMood, args: (status, simpleSummary, groupList))
    }
}
