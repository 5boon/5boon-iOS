//
//  Networking.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/26.
//  Copyright © 2020 5boon. All rights reserved.
//

import Alamofire
import Immutable
import Moya
import RxSwift

// MARK: typealias API Networking
typealias UserNetworking = Networking<UserAPI>
typealias AuthNetworking = Networking<AuthAPI>
typealias MoodNetworking = Networking<MoodAPI>
typealias GroupNetworking = Networking<GroupAPI>

final class Networking<Target: TargetType>: MoyaProvider<Target> {
    init(plugins: [PluginType] = []) {
        var finalPlugins: [PluginType] = []
        finalPlugins.append(contentsOf: plugins)
        // finalPlugins.append(NetworkLoggerPlugin())
        
        let endpointClosure = { (target: Target) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["User-Agent": Secrets.userAgent])
        }
        
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        super.init(endpointClosure: endpointClosure, session: session, plugins: finalPlugins)
    }

    func request(_ target: Target) -> Observable<Response> {
        
        let requestString = "\(target.method.rawValue) \(target.path)"
        
        let actualRequest = self.rx.request(target)
            
        return self.checkAndRefreshToken()
            .flatMap { _ in actualRequest }
            .do(onNext: { response in
                let message = "SUCCESS: \(requestString) (\(response.statusCode))"
                logger.debug(message)
            }, onError: { error in
                if let response = (error as? MoyaError)?.response {
                    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                        logger.warning(message)
                    } else if let rawString = String(data: response.data, encoding: .utf8) {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                        logger.warning(message)
                    } else {
                        let message = "FAILURE: \(requestString) (\(response.statusCode))"
                        logger.warning(message)
                    }
                } else {
                    let message = "FAILURE: \(requestString)\n\(error)"
                    logger.warning(message)
                }
            }, onSubscribed: {
                let message = "REQUEST: \(requestString)"
                logger.debug(message)
            })
        
    }
//        return self.rx.request(target)
//            .filterSuccessfulStatusCodes()
//            .do(
//                onSuccess: { value in
//                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
//                    logger.debug(message)
//            },
//                onError: { error in
//                    if let response = (error as? MoyaError)?.response {
//                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
//                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
//                            logger.warning(message)
//                        } else if let rawString = String(data: response.data, encoding: .utf8) {
//                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
//                            logger.warning(message)
//                        } else {
//                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
//                            logger.warning(message)
//                        }
//                    } else {
//                        let message = "FAILURE: \(requestString)\n\(error)"
//                        logger.warning(message)
//                    }
//            },
//                onSubscribed: {
//                    let message = "REQUEST: \(requestString)"
//                    logger.debug(message)
//            }
//        )
//    }
    
    func checkAndRefreshToken() -> Observable<String?> {
        
        guard let authPlugin = self.plugins.filter({ $0 is AuthPlugin }).first as? AuthPlugin else {
            return .empty()
        }
        let authService = authPlugin.authService
        guard let token = authService.currentAccessToken else {
            return .empty()
        }
        
        // 토큰이 유효한 경우
        if token.isValid {
            return Observable.just(token.accessToken)
        }
        
        // 토큰이 만료된 경우
        return authService.refreshToken(token: token.refreshToken)
    }
}
