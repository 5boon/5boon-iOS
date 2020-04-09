//
//  String+Date.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/02.
//

import Foundation

extension String {
    func date(dateFormat: String, tz: TimeZone? = nil, calendar: Calendar? = nil) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = tz ?? .current
        dateFormatter.calendar = calendar ?? Calendar(identifier: .gregorian) // 서버시간 시간 string을 변환하므로 gregorian으로 처리
        return dateFormatter.date(from: self)
    }
    
    func convertServerDate() -> Date? {
        return self.date(dateFormat: Constants.DateFormats.iso8601)
    }
}
