//
//  AuthFacebook+Ext.swift
//  UVIO
//
//  Created by Macostik on 07.06.2022.
//

import Foundation
import Combine
import FBSDKLoginKit

extension LoginManager {
    func authorizePublisher() -> FacebookPublisher {
        return FacebookPublisher(loginManager: self)
    }
    struct FacebookPublisher: Publisher {
        // swiftlint:disable nesting
        typealias Output = Token?
        typealias Failure = Error
        private let loginManager: LoginManager
        fileprivate init(loginManager: LoginManager) {
            self.loginManager = loginManager
        }
        func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = FacebookSubscription(loginManager: loginManager, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.authorize(loginManager: loginManager)
        }
    }
    private class FacebookSubscription<S: Subscriber>: Subscription
    where S.Input == Token?, S.Failure == Error {
        private let loginManager: LoginManager
        private var subscriber: S?
        init(loginManager: LoginManager, subscriber: S) {
            self.loginManager = loginManager
            self.subscriber = subscriber
        }
        func authorize(loginManager: LoginManager) {
            loginManager.logIn(permissions: [.publicProfile, .email],
                               viewController: nil) { result in
                switch result {
                case .success(_, _, let accessToken):
                    _ = self.subscriber?.receive(accessToken?.tokenString)
                case .cancelled:
                    _ = self.subscriber?.receive(completion: Subscribers.Completion.finished)
                case .failed(let error) :
                    _ = self.subscriber?.receive(completion: Subscribers.Completion.failure(error))
                }
            }
        }
        func cancel() {
            subscriber = nil
        }
        func request(_ demand: Subscribers.Demand) {}
    }
}
