//
//  ASAuthorizationControllerh+Ext.swift
//  UVIO
//
//  Created by Macostik on 07.06.2022.
//

import Foundation
import Combine
import AuthenticationServices

extension ASAuthorizationController {
    func loadProvider() -> AppleProviderPublisher {
        return AppleProviderPublisher(client: self)
    }
    struct AppleProviderPublisher: Publisher {
        // swiftlint:disable nesting
        typealias Output = ASAuthorizationAppleIDProvider.CredentialState
        typealias Failure = Error
        private let client: ASAuthorizationController
        fileprivate init(client: ASAuthorizationController) {
            self.client = client
        }
        func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = AppleProviderSubscription(client: client, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.prepareProvider()
        }
    }
    private class AppleProviderSubscription<S: Subscriber>: NSObject, Subscription, ASAuthorizationControllerDelegate
    where S.Input == ASAuthorizationAppleIDProvider.CredentialState, S.Failure == Error {
        private let client: ASAuthorizationController
        private var subscriber: S?
        init(client: ASAuthorizationController, subscriber: S) {
            self.client = client
            self.subscriber = subscriber
        }
        func prepareProvider() {
            client.delegate = self
            client.performRequests()
        }
        func cancel() {
            subscriber = nil
        }
        func request(_ demand: Subscribers.Demand) {}
        func authorizationController(controller: ASAuthorizationController,
                                     didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                ASAuthorizationAppleIDProvider().getCredentialState(forUserID: credential.user,
                                                                    completion: { credentialState, error in
                    guard let error = error else {
                        _ = self.subscriber?.receive(credentialState)
                        return
                    }
                    _ = self.subscriber?.receive(completion: Subscribers.Completion.failure(error))
                })
            }
        }
        func authorizationController(controller: ASAuthorizationController,
                                     didCompleteWithError error: Error) {
            _ = subscriber?.receive(completion: Subscribers.Completion.failure(error))
        }
    }
}
