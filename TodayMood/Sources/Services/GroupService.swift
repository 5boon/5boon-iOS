//
//  GroupService.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/09.
//

import RxSwift

protocol GroupServiceType {
    func groupList() -> Observable<[PublicGroup]>
}

final class GroupService: GroupServiceType {
    
    private let networking: GroupNetworking
    
    init(networking: GroupNetworking) {
        self.networking = networking
    }
    
    func groupList() -> Observable<[PublicGroup]> {
        return self.networking.request(.groupList)
            .debug()
            .asObservable()
            .map([PublicGroup].self)
            .do(onNext: { groups in
                GlobalStates.shared.groups.accept(groups)
            })
    }
}