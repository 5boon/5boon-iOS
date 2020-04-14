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
        return id.count > 3 // 4자 이상
    }
    
    static func validateEmail(_ email: String?) -> Bool {
        guard let email = email, email.isNotEmpty else { return false }
        
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailValidate = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return emailValidate.evaluate(with: email)
    }
    
    static func validatePassword(_ password: String?) -> Bool {
        guard let password = password else { return false }
        return password.count > 3
    }
    
    static func validateNickName(_ nickName: String?) -> Bool {
        guard let nickName = nickName else { return false }
        return nickName.isNotEmpty
    }
}
