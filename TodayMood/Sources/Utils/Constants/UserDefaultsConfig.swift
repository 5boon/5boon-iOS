//
//  UserDefaultsConfig.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/17.
//

struct UserDefaultsConfig {
    @UserDefaultsWrapper(Constants.UserDefaultKeys.firstLaunch, defaultValue: true)
    static var firstLaunch: Bool
}
