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
    
    func refreshToken(refreshToken: String) -> Observable<String?>
}

final class AuthService: AuthServiceType {
    
    // MARK: Properties
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
        try self.keychain.set(accessToken.refreshToken, key: Constants.KeychainKeys.refreshToken)
        try self.keychain.set(accessToken.expired, key: Constants.KeychainKeys.expired)
    }
    
    fileprivate func loadAccessToken() -> AccessToken? {
        guard let accessToken = self.keychain[Constants.KeychainKeys.accessToken],
            let tokenType = self.keychain[Constants.KeychainKeys.tokenType],
            let refreshToken = self.keychain[Constants.KeychainKeys.refreshToken],
            let expired = self.keychain[Constants.KeychainKeys.expired] else { return nil }
        return AccessToken(accessToken: accessToken, tokenType: tokenType, refreshToken: refreshToken, expired: expired)
    }
    
    fileprivate func deleteAccessToken() {
        try? self.keychain.remove(Constants.KeychainKeys.accessToken)
        try? self.keychain.remove(Constants.KeychainKeys.tokenType)
        try? self.keychain.remove(Constants.KeychainKeys.refreshToken)
        try? self.keychain.remove(Constants.KeychainKeys.expired)
    }
    
    // MARK: Handle authorize
    func requestToken(userName: String, password: String) -> Observable<Void> {
        return self.networking.rx.request(.requestToken(userName: userName, password: password))
            .debug()
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
    
    func refreshToken(refreshToken: String) -> Observable<String?> {
        return self.networking.rx.request(.refreshToken(refreshToken: refreshToken))
            .debug()
            .asObservable()
            .map(AccessToken.self)
            .do(onNext: { [weak self] token in
                try self?.saveAccessToken(token)
                self?.currentAccessToken = token
            })
            .map { $0.accessToken }
    }
}
