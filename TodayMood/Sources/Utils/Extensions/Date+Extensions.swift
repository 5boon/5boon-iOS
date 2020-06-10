//
//  Date+Extensions.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import Foundation

// MARK: Time Ago
extension Date {
    // https://gist.github.com/minorbug/468790060810e0d29545
    func timeAgo(numericDates: Bool = true) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        switch (year, month, weekOfMonth, day, hour, minute, second) {
        case (let year, _, _, _, _, _, _) where year >= 2: return "\(year)년 전"
        case (let year, _, _, _, _, _, _) where year == 1 && numericDates: return "작년"
        case (let year, _, _, _, _, _, _) where year == 1 && !numericDates: return "작년"
        case (_, let month, _, _, _, _, _) where month >= 2: return "\(month)달 전"
        case (_, let month, _, _, _, _, _) where month == 1 && numericDates: return "지난 달"
        case (_, let month, _, _, _, _, _) where month == 1 && !numericDates: return "지난 달"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth)주 전"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && numericDates: return "지난 주"
        case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && !numericDates: return "지난 주"
        case (_, _, _, let day, _, _, _) where day >= 2: return "\(day)일 전"
        case (_, _, _, let day, _, _, _) where day == 1 && numericDates: return "어제"
        case (_, _, _, let day, _, _, _) where day == 1 && !numericDates: return "어제"
        case (_, _, _, _, let hour, _, _) where hour >= 2: return "\(hour)시간 전"
        case (_, _, _, _, let hour, _, _) where hour == 1 && numericDates: return "한시간 전"
        case (_, _, _, _, let hour, _, _) where hour == 1 && !numericDates: return "한시간 전"
        case (_, _, _, _, _, let minute, _) where minute >= 2: return "\(minute)분 전"
        case (_, _, _, _, _, let minute, _) where minute == 1 && numericDates: return "1분 전"
        case (_, _, _, _, _, let minute, _) where minute == 1 && !numericDates: return "1분 전"
        case (_, _, _, _, _, _, let second) where second >= 3: return "\(second)초 전"
        default: return "방금 전"
        }
    }
}

// MARK: Standard
extension Date {
    static func startOfToday() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: Date())
    }
    
    func startOfDay() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
}

// MARK: Calculate Date
extension Date {
    func add(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar(identifier: .gregorian).date(byAdding: component, value: value, to: self)
    }
}
