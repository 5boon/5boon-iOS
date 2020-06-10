//
//  PublicGroupSection.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/10.
//

import Foundation

import RxDataSources

enum PublicGroupSection {
    case groupList([PublicGroupSectionItem])
}

extension PublicGroupSection: SectionModelType {
    var items: [PublicGroupSectionItem] {
        switch self {
        case .groupList(let items):
            return items
        }
    }
    
    init(original: PublicGroupSection, items: [PublicGroupSectionItem]) {
        switch original {
        case .groupList:
            self = .groupList(items)
        }
    }
}

enum PublicGroupSectionItem {
    case groupList(PublicGroupCellReactor)
}
