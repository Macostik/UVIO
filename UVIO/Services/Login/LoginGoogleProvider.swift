//
//  LoginGoogleProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Combine
import GoogleSignIn
import RealmSwift

protocol LoginGoogleProvider {
    var googleLoginService: LoginGoogleInteractor { get }
}

struct LoginGoogleService: LoginGoogleInteractor {
    private var configuration: GIDConfiguration = {
        return GIDConfiguration(clientID: Constant.clientID)
    }()
    private let rootViewController: UIViewController = {
        UIApplication.shared.windows.first?.rootViewController ?? UIViewController()
    }()
    func login() -> AnyPublisher<UserData, Error> {
        let subject = PassthroughSubject<UserData, Error>()
        GIDSignIn.sharedInstance.signIn(with: configuration,
                                        presenting: rootViewController) { user, error in
            if let user = user {
                Logger.info("Google login was successful with user: \(user)")
                let name = user.profile?.name ?? ""
                let email = user.profile?.email ?? ""
                subject.send((name, email))
                subject.send(completion: .finished)
            }
            if let error = error {
                Logger.error("Error! \(String(describing: error))")
                subject.send(completion: .failure(error))
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
