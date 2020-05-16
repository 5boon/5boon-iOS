//
//  StubGlobalStates.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/25.
//

import Foundation

import RxSwift

@testable import TodayMood

final class StubGlobalStates {
    
    static let shared = StubGlobalStates()
    
    // Current User
    let userSubject = ReplaySubject<User?>.create(bufferSize: 1)
    lazy var currentUser: Observable<User?> = self.userSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)
    
    // Current Access Token
    var currentAccessToken: AccessToken?
}


