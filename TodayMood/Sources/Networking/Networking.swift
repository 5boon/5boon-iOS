//
//  Networking.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/26.
//  Copyright © 2020 5boon. All rights reserved.
//

import Moya
import RxSwift

final class Networking<Target: TargetType>: MoyaProvider<Target> {
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        super.init(session: session, plugins: plugins)
    }

    func request(_ target: Target) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return self.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    logger.debug(message)
            },
                onError: { error in
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
            },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    logger.debug(message)
            }
        )
    }
}
