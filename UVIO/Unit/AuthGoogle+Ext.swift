//
//  AuthGoogle+Ext.swift
//  UVIO
//
//  Created by Macostik on 07.06.2022.
//

import Foundation
import Combine
import GoogleSignIn

extension GIDSignIn {
    func authorizePublisher() -> GoogleSingInPublisher {
        return GoogleSingInPublisher(loginManager: self)
    }
    struct GoogleSingInPublisher: Publisher {
        // swiftlint:disable nesting
        typealias Output = Token?
        typealias Failure = Error
        private let loginManager: GIDSignIn
        fileprivate init(loginManager: GIDSignIn) {
            self.loginManager = loginManager
        }
        func receive<S: Subscriber>(subscriber: S)
        where Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = GoogleSingInSubscription(loginManager: loginManager,
                                                        subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.signIn(loginManager: loginManager)
        }
    }
    private class GoogleSingInSubscription<S: Subscriber>: Subscription
    where S.Input == Token?, S.Failure == Error {
        private let loginManager: GIDSignIn
        private var subscriber: S?
        init(loginManager: GIDSignIn, subscriber: S) {
            self.loginManager = loginManager
            self.subscriber = subscriber
        }
        func signIn(loginManager: GIDSignIn) {
            loginManager.signIn(with: GIDConfiguration(clientID: Constant.clientID),
                                presenting: rootViewController) { user, error in
                guard let user = user else {
                    if let error = error {
                        _ = self.subscriber?
                            .receive(completion: Subscribers.Completion.failure(error))
                    }
                    return
                }
                _ = self.subscriber?.receive(user.authentication.accessToken)
            }
        }
        func cancel() {
            subscriber = nil
        }
        func request(_ demand: Subscribers.Demand) {}
    }
}
