//
//  LoginFacebookProvider.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import Foundation
import FBSDKLoginKit

struct FBUser {
    var facebookID: String
    var name: String
    var email: String
    var id: Int
}

class CurrentUser: ObservableObject {
    @Published var user = FBUser(facebookID: "", name: "", email: "", id: 0)
}

class LoginFacebookProvider: ObservableObject {
    let loginManager = LoginManager()
    func facebookLogin(cUser: CurrentUser) {
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, first_name"])
                    .start(completion: { (connection, result, error) -> Void in
//                    if (error == nil){
//                        let fbDetails = result as! NSDictionary
//                        print(fbDetails)
//                        let user = User(facebookId: fbDetails["id"] as! String, name: fbDetails["name"] as! String, email: fbDetails["email"] as! String, id: 0)
//                        AccountEndpoints.createUser(user: user)
//                        cUser.user = user
//                    }
                })
            }
        }
    }
}
