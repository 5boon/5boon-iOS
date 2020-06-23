//
//  GroupService.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/09.
//

import RxSwift

protocol GroupServiceType {
    func groupList() -> Observable<[PublicGroup]>
    func createGroup(title: String, summary: String) -> Observable<MoodGroup>
    func joinGroup(groupCode: String) -> Observable<PublicGroup>
    func groupDetail(groupID: Int, displayMine: Bool) -> Observable<[GroupMemberMood]>
}

extension GroupServiceType {
    func groupDetail(groupID: Int, displayMine: Bool = false) -> Observable<[GroupMemberMood]> {
        return self.groupDetail(groupID: groupID, displayMine: displayMine)
    }
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
    
    func createGroup(title: String, summary: String) -> Observable<MoodGroup> {
        return self.networking.request(.createGroup(title: title, summary: summary))
            .debug()
            .asObservable()
            .map(MoodGroup.self)
    }
    
    func joinGroup(groupCode: String) -> Observable<PublicGroup> {
        return self.networking.request(.joinGroup(groupCode: groupCode))
            .debug()
            .asObservable()
            .map(PublicGroup.self)
    }
    
    func groupDetail(groupID: Int, displayMine: Bool = false) -> Observable<[GroupMemberMood]> {
        return self.networking.request(.groupDetail(groupID: groupID, displayMine: displayMine))
            .debug()
            .asObservable()
            .map([GroupMemberMood].self)
    }
}
