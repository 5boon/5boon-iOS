//
//  String+Validation.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/21.
//

import Foundation

extension String {
    static func validateID(_ id: String?) -> Bool {
        guard let id = id else { return false }
        return id.isNotEmpty
    }
    
    static func validateEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        return email.isNotEmpty
    }
    
    static func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.isNotEmpty
    }
    
    static func validateNickName(_ nickName: String?) -> Bool {
        guard let nickName = nickName else { return false }
        return nickName.isNotEmpty
    }
}
