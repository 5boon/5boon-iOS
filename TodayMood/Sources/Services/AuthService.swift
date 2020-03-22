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
    
    func requestToken(userName: String, password: String) -> Observable<Void>
    
    func logout()
}

final class AuthService: AuthServiceType {
    
    // MARK: Properties
    private var cliendID: String = Constants.OAuthKeys.clientID
    private var clientSecret: String = Constants.OAuthKeys.clientSecret
    
    private(set) var currentAccessToken: AccessToken?
    
    private let navigator: NavigatorType
    private let keychain = Keychain(service: Constants.KeychainKeys.serviceName)
    private let networking: AuthNetworking
    
    init(navigator: NavigatorType, networking: AuthNetworking) {
        self.navigator = navigator
        self.networking = networking
        self.currentAccessToken = self.loadAccessToken()
        if let currentAccessToken = self.currentAccessToken {
            logger.debug("currentAccessToken: \(currentAccessToken)")
        }
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
    func requestToken(userName: String, password: String) -> Observable<Void> {
        return self.networking.request(.requestToken(userName: userName, password: password))
            .asObservable()
            .map(AccessToken.self)
            .do(onNext: { [weak self] token in
                try self?.saveAccessToken(token)
                self?.currentAccessToken = token
            })
            .map { _ in }
    }
    
    func logout() {
        self.currentAccessToken = nil
        self.deleteAccessToken()
    }
}
