//
//  MoodStatusSection.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/20.
//

import Foundation

import RxDataSources

enum MoodStatusSection {
    case status([MoodStatusSectionItem])
}

extension MoodStatusSection: SectionModelType {
    var items: [MoodStatusSectionItem] {
        switch self {
        case .status(let items):
            return items
        }
    }
    
    init(original: MoodStatusSection, items: [MoodStatusSectionItem]) {
        switch original {
        case .status:
            self = .status(items)
        }
    }
}

enum MoodStatusSectionItem {
    case status(MoodStatusCellReactor)
}
