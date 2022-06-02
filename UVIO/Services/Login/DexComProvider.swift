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
    func getBearer() -> AnyPublisher<String, Error> {
        let oauth2 = OAuth2Swift(consumerKey: Constant.dexcomSecretClientID,
                                 consumerSecret: Constant.dexcomSecretKey,
                                 authorizeUrl: Constant.authURL,
                                 accessTokenUrl: Constant.authToken,
                                 responseType: Constant.authType)
        let state = generateState(withLength: 20)
        return oauth2.authorizePublisher(callbackURL: Constant.returnURL,
                                         scope: Constant.authScope,
                                         state: state)
            .map { credential, _, _ in credential.oauthToken }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
