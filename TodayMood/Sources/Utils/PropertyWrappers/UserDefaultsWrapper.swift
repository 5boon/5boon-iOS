//
//  UserDefaultsWrapper.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/17.
//

import Foundation

@propertyWrapper struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
