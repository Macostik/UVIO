//
//  AppleProvider.swift
//  UVIO
//
//  Created by Macostik on 06.06.2022.
//

import Foundation
import Combine
import AuthenticationServices

protocol AppleProvider {
    var appleService: AppleInteractor { get }
}

struct AppleService: AppleInteractor {
    func signIn() -> AnyPublisher<UserData, Error> {
        let subject = PassthroughSubject<UserData, Error>()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = rootViewController
        authorizationController.performRequests()
        return subject.eraseToAnyPublisher()
    }
}

extension UIViewController: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: credential.user,
                                                                completion: { credentialState, error in
                if let error = error {
                    Logger.error("Sign In with Apple error: \(error.localizedDescription)")
                    return
                }
                var authState = ""
                switch credentialState {
                case .authorized: authState = "authorized"
                case .notFound: authState = "notFound"
                case .revoked: authState = "revoked"
                case .transferred: authState = "transferred"
                default: break
                }
                Logger.info("User Apple singIn state: \(authState)")
            })
        }
    }
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithError error: Error) {
        Logger.error("Sign In with Apple error: \(error.localizedDescription)")
    }
}
