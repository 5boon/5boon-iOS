//
//  String+OAuth.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/28.
//

import Foundation

extension String {
//    static func base64Credentials() -> String {
//        let username = Secrets.clientID
//        let password = Secrets.clientSecret
//        let basicAuthCredentials = "\(username):\(password)".data(using: .utf8)
//        let base64AuthCredentials = basicAuthCredentials?.base64EncodedString(options: .lineLength64Characters) ?? ""
//        logger.debug("Basic Credentials: \(base64AuthCredentials)")
//        return String(format: "Basic %@", base64AuthCredentials)
//    }
     
    static var base64Credentials: String {
        let username = Secrets.clientID
        let password = Secrets.clientSecret
        let basicAuthCredentials = "\(username):\(password)".data(using: .utf8)
//        let base64AuthCredentials = basicAuthCredentials?.base64EncodedString(options: .lineLength64Characters) ?? ""
        let base64AuthCredentials = basicAuthCredentials?.base64EncodedString() ?? ""
        // logger.debug("Basic Credentials: \(base64AuthCredentials)")
        return String(format: "Basic %@", base64AuthCredentials)
    }
}
