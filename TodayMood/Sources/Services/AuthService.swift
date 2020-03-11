//
//  AuthService.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/07.
//

import Alamofire
import KeychainAccess
import RxSwift
import URLNavigator

protocol AuthServiceType {
    var currentAccessToken: AccessToken? { get }
    
    func authorize() -> Observable<Void>
    
    func callback(code: String)
    
    func logout()
}
/**
 {
   "access_token": "87hSndIu7be5JhNPE2JlWQjgOkmLzY",
   "expires_in": 36000,
   "token_type": "Bearer",
   "scope": "read write",
   "refresh_token": "GeSBuiGfN8SQITON6PMHdFYyoSlsKm"
 }
 */
final class AuthService: AuthServiceType {
    
    // MARK: Properties
    private var cliendID: String = Constants.OAuthKeys.clientID
    private var clientSecret: String = Constants.OAuthKeys.clientSecret
    
    private(set) var currentAccessToken: AccessToken?
    
    private let navigator: NavigatorType
    private let keychain = Keychain(service: Constants.KeychainKeys.serviceName)
    
    init(navigator: NavigatorType) {
        self.navigator = navigator
        self.currentAccessToken = self.loadAccessToken()
        logger.debug("currentAccessToken: \(self.currentAccessToken)")
    }
    
    // MARK: Handle Access Token
    fileprivate func saveAccessToken(_ accessToken: AccessToken) throws {
        try self.keychain.set(accessToken.accessToken, key: Constants.KeychainKeys.accessToken)
        try self.keychain.set(accessToken.tokenType, key: Constants.KeychainKeys.tokenType)
        try self.keychain.set(accessToken.scope, key: Constants.KeychainKeys.scope)
        try self.keychain.set(accessToken.refreshToken, key: Constants.KeychainKeys.refreshToken)
    }
    
    fileprivate func loadAccessToken() -> AccessToken? {
        guard let accessToken = self.keychain[Constants.KeychainKeys.accessToken],
            let tokenType = self.keychain[Constants.KeychainKeys.tokenType],
            let scope = self.keychain[Constants.KeychainKeys.scope],
            let refreshToken = self.keychain[Constants.KeychainKeys.refreshToken] else { return nil }
        return AccessToken(accessToken: accessToken, tokenType: tokenType, scope: scope, refreshToken: refreshToken)
    }
    
    fileprivate func deleteAccessToken() {
        try? self.keychain.remove(Constants.KeychainKeys.accessToken)
        try? self.keychain.remove(Constants.KeychainKeys.tokenType)
        try? self.keychain.remove(Constants.KeychainKeys.scope)
        try? self.keychain.remove(Constants.KeychainKeys.refreshToken)
    }
    
    // MARK: Handle authorize
    func authorize() -> Observable<Void> {
        return .empty()
    }
    
    func callback(code: String) {
        
    }
    
    func logout() {
        
    }
}
