//
//  StubGroupService.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/05/15.
//

import RxSwift
import Stubber

@testable import TodayMood

final class StubGroupService: GroupServiceType {
    func groupList() -> Observable<[PublicGroup]> {
        return Stubber.invoke(groupList, args: (), default: .never())
    }
}
