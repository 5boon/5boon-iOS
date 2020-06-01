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
    case good = 20
    case soso = 15
    case mope = 10
    case bad = 5
    case worst = 0
    
    var iconName: String {
        switch self {
        case .best:
            return "ic_best"
        case .good:
            return "ic_happy"
        case .soso:
            return "ic_soso"
        case .mope:
            return "ic_terrible"
        case .bad:
            return "ic_bad"
        case .worst:
            return "ic_terrible"
        }
    }
    
    var title: String {
        switch self {
        case .best:
            return "최고에요"
        case .good:
            return "좋아요"
        case .soso:
            return "그냥 그래요"
        case .mope:
            return "우울해요"
        case .bad:
            return "나빠요"
        case .worst:
            return "최악이에요"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .best:
            return UIColor.moodBest
        case .good:
            return UIColor.moodHappy
        case .soso:
            return UIColor.moodSoso
        case .mope:
            return UIColor.moodDepressed
        case .bad:
            return UIColor.moodBad
        case .worst:
            return UIColor.moodTerrible
        }
    }
    
    var gradientTop: UIColor {
        switch self {
        case .best:
            return UIColor(hexString: "#EA6D7D")
        case .good:
            return UIColor(hexString: "#EA8E9A")
        case .soso:
            return UIColor(hexString: "#F4B1BA")
        case .mope:
            return UIColor(hexString: "#9795FF")
        case .bad:
            return UIColor(hexString: "#5070C2")
        case .worst:
            return UIColor(hexString: "#494F67")
        }
    }
    
    var gradientBottom: UIColor {
        switch self {
        case .best:
            return UIColor(hexString: "#EA8E9A")
        case .good:
            return UIColor(hexString: "#F4B1BA")
        case .soso:
            return UIColor(hexString: "#9795FF")
        case .mope:
            return UIColor(hexString: "#5070C2")
        case .bad:
            return UIColor(hexString: "#494F67")
        case .worst:
            return UIColor(hexString: "#383B47") 
        }
    }
}
