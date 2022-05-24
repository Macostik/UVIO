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
    func loginThroughtFacebook() -> AnyPublisher<User, Error>
}

class LoginFacebookService: LoginFacebookProvider {
    let loginManager = LoginManager()
    func loginThroughtFacebook() -> AnyPublisher<User, Error> {
        let subject = PassthroughSubject<User, Error>()
         loginManager.logIn(permissions: [.publicProfile, .email],
                           viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                print("Logged was successful with \(accessToken.debugDescription)")
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, first_name"])
                    .start(completion: { _, result, error in
                        if let error = error {
                            print("Facebook sing in was fail - \(error)")
                        }
                        if result != nil, let fbDetails = result as? [String: String] {
                            let user = User()
                            user.id =  fbDetails["id"] ?? ""
                            user.name = fbDetails["name"] ?? ""
                            user.email = fbDetails["email"] ?? ""
                            subject.send(user)
                        }
                })
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
