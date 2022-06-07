//
//  AppleProvider.swift
//  UVIO
//
//  Created by Macostik on 06.06.2022.
//

import Foundation
import Combine
import AuthenticationServices
import RealmSwift

protocol AppleProvider {
    var appleService: AppleInteractor { get }
}

struct AppleService: AppleInteractor {
    func singIn() -> AnyPublisher<ASAuthorizationAppleIDProvider.CredentialState, Error> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        return authorizationController.loadProvider()
            .eraseToAnyPublisher()
    }
}
