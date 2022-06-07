//
//  AppleInteractor.swift
//  UVIO
//
//  Created by Macostik on 06.06.2022.
//

import Foundation
import Combine
import AuthenticationServices

protocol AppleInteractor {
    func singIn() -> AnyPublisher<ASAuthorizationAppleIDProvider.CredentialState, Error>
}
