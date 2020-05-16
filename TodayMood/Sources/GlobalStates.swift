//
//  GlobalStates.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/09.
//

import Foundation

import RxCocoa
import RxSwift

final class GlobalStates {
    
    static let shared = GlobalStates()
    
    // MARK: 내 정보
    var currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    
    // MARK: 내가 속한 그룹 목록
    let groups: BehaviorRelay<[PublicGroup]> = BehaviorRelay(value: [])
}
