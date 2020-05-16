//
//  MoodWriteGroupSection.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/11.
//

import RxDataSources

enum MoodWriteGroupSection {
    case group([MoodWriteGroupSectionItem])
}

extension MoodWriteGroupSection: SectionModelType {
    var items: [MoodWriteGroupSectionItem] {
        switch self {
        case .group(let items):
            return items
        }
    }
    
    init(original: MoodWriteGroupSection, items: [MoodWriteGroupSectionItem]) {
        switch original {
        case .group:
            self = .group(items)
        }
    }
}

enum MoodWriteGroupSectionItem {
    case group(MoodWriteGroupListCellReactor)
}
