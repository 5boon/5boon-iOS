//
//  GroupDetailMoodSection.swift
//  TodayMood
//
//  Created by Kanz on 2020/07/12.
//

import Foundation

import RxDataSources

enum GroupDetailMoodSection {
    case groupMood([GroupDetailMoodSectionItem])
}

extension GroupDetailMoodSection: SectionModelType {
    
    var items: [GroupDetailMoodSectionItem] {
        switch self {
        case .groupMood(let items):
            return items
        }
    }
    
    init(original: GroupDetailMoodSection, items: [GroupDetailMoodSectionItem]) {
        switch original {
        case .groupMood:
            self = .groupMood(items)
        }
    }
}

enum GroupDetailMoodSectionItem {
    case groupMood(GroupDetailMoodCellReactor)
}
