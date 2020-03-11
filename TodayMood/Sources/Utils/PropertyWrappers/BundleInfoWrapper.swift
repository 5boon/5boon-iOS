//
//  BundleInfo.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import Foundation

/// Info.plist의 값을 가져오는 Property Wrapper
@propertyWrapper struct BundleInfoWrapper<T> {
    let key: String
    
    var wrappedValue: T {
        return Bundle.main.infoDictionary![key] as! T
    }
}
