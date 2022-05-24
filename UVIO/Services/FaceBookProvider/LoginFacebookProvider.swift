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

class LoginFacebookProvider: ObservableObject {
    let loginManager = LoginManager()
    let userPublisher =  PassthroughSubject<User?, Never>()
    func facebookLogin() {
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
                            print("FaceBook sing in was fail - \(error)")
                        }
                        if result != nil, let fbDetails = result as? [String: String] {
                            let user = User()
                            user.id =  fbDetails["id"] ?? ""
                            user.name = fbDetails["first_name"] ?? ""
                            user.email = fbDetails["email"] ?? ""
                            self.userPublisher.send(user)
                        }
                })
            }
        }
    }
}
