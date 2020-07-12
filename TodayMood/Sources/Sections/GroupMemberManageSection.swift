//
//  GroupMemberManageSection.swift
//  TodayMood
//
//  Created by Kanz on 2020/07/11.
//

import Foundation

import RxDataSources

enum GroupMemberManageSection {
    case memberList([GroupMemberManageSectionItem])
}

extension GroupMemberManageSection: SectionModelType {
    
    var items: [GroupMemberManageSectionItem] {
        switch self {
        case .memberList(let items):
            return items
        }
    }
    
    init(original: GroupMemberManageSection, items: [GroupMemberManageSectionItem]) {
        switch original {
        case .memberList:
            self = .memberList(items)
        }
    }
}

enum GroupMemberManageSectionItem {
    case memberList(GroupMemberManageCellReactor)
}
