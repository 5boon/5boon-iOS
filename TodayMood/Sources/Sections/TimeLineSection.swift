//
//  TimeLineSection.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import RxDataSources
// HomeTimeLineCellReactor
enum TimeLineSection {
    case timeLine([TimeLineSectionItem])
}

extension TimeLineSection: SectionModelType {
    
    var items: [TimeLineSectionItem] {
        switch self {
        case .timeLine(let items):
            return items
        }
    }
    
    init(original: TimeLineSection, items: [TimeLineSectionItem]) {
        switch original {
        case .timeLine:
            self = .timeLine(items)
        }
    }
}

enum TimeLineSectionItem {
    case timeLine(HomeTimeLineCellReactor)
}
