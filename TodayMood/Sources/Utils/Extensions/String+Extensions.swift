//
//  String+Extensions.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/19.
//

import Foundation

extension String {
    static func jsonString(json: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
