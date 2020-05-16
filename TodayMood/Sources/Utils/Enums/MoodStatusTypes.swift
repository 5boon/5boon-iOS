//
//  MoodStatusTypes.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/20.
//

import Foundation

import RxDataSources
// WORST, BAD, MOPE, SOSO, GOOD, BEST = 0, 5, 10, 15, 20, 25
// -1 은 미입력

enum MoodStatusTypes: Int, CaseIterable, IdentifiableType {
    typealias Identity = Int
    var identity: Int { rawValue }
    
    case best = 25
    case happy = 20
    case soso = 15
    case depressed = 10
    case bad = 5
    case terrible = 0
    
    var iconName: String {
        switch self {
        case .best:
            return "ic_best"
        case .happy:
            return "ic_happy"
        case .soso:
            return "ic_soso"
        case .depressed:
            return "ic_terrible"
        case .bad:
            return "ic_bad"
        case .terrible:
            return "ic_terrible"
        }
    }
    
    var title: String {
        switch self {
        case .best:
            return "최고에요"
        case .happy:
            return "좋아요"
        case .soso:
            return "그냥 그래요"
        case .depressed:
            return "우울해요"
        case .bad:
            return "나빠요"
        case .terrible:
            return "최악이에요"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .best:
            return UIColor.moodBest
        case .happy:
            return UIColor.moodHappy
        case .soso:
            return UIColor.moodSoso
        case .depressed:
            return UIColor.moodDepressed
        case .bad:
            return UIColor.moodBad
        case .terrible:
            return UIColor.moodTerrible
        }
    }
}
