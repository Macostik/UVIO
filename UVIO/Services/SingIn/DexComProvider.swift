//
//  DexComProvider.swift
//  UVIO
//
//  Created by Macostik on 02.06.2022.
//

import Combine
import OAuthSwift
import Foundation

protocol DexcomProvider {
    var dexcomService: DexcomInteractor { get }
}

struct DexcomService: DexcomInteractor {
    func getBearer() -> AnyPublisher<DexcomToken, Error> {
        let oauth2 = OAuth2Swift(consumerKey: Constant.dexcomSecretClientID,
                                 consumerSecret: Constant.dexcomSecretKey,
                                 authorizeUrl: Constant.authURL,
                                 accessTokenUrl: Constant.authToken,
                                 responseType: Constant.authType)
        let state = generateState(withLength: 20)
        return oauth2.authorizePublisher(callbackURL: Constant.returnURL,
                                         scope: Constant.authScope,
                                         state: state)
            .map { credential, _, _ in
                let token = DexcomToken(oauthToken: credential.oauthToken,
                                        oauthRefreshToken: credential.oauthRefreshToken)
                Logger.info("Dexcom login was successful with token: \(token)")
                return token
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
