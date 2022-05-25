//
//  AuthProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Resolver

typealias AuthProvider = LoginFacebookProvider & LoginGoogleProvider

struct AuthService: AuthProvider {
    var facebookLoginService: LoginFacebookInteractor {
        LoginFacebookServiceCase()
    }
    var googleLoginService: LoginGoogleInteractor {
        LoginGoogleServiceCase()
    }
}
