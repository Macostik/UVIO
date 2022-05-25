//
//  LoginFacebookProvider.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import Foundation
import FBSDKLoginKit
import Combine
import UIKit

protocol LoginFacebookProvider {
    var facebookLoginService: LoginFacebookInteractor { get }
}

struct LoginFacebookService: LoginFacebookInteractor {
    let loginManager = LoginManager()
    func login() -> AnyPublisher<User, Error> {
        let subject = PassthroughSubject<User, Error>()
        loginManager.logIn(permissions: [.publicProfile, .email],
                           viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                Logger.error("Login via Facebook was failed \(error)")
                subject.send(completion: .failure(error))
            case .cancelled:
                print("User cancelled login.")
                subject.send(completion: .finished)
            case .success(_, _, let accessToken):
                Logger.info("Facebook login was successful with token \(accessToken.debugDescription)")
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, first_name"])
                    .start(completion: { _, result, error in
                        if let error = error {
                            Logger.error("Facebook sing in was fail - \(error)")
                            subject.send(completion: .failure(error))
                        }
                        if result != nil, let fbDetails = result as? [String: String] {
                            let user = User()
                            user.id =  fbDetails["id"] ?? ""
                            user.name = fbDetails["name"] ?? ""
                            user.email = fbDetails["email"] ?? ""
                            subject.send(user)
                            subject.send(completion: .finished)
                        }
                    })
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
