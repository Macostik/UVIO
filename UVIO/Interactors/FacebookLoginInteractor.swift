//
//  FacebookLoginInteractor.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import Resolver
import Combine
import FacebookLogin

protocol LoginFacebookInteractorType {
    func loginThroughFacebook() -> AnyPublisher<User, Error>
//    func loginTrhoughGoogle() -> AnyPublisher<User?, Error>
//    func loginThroughtApple() -> AnyPublisher<User?, Error>
}

class LoginFacebookInteractor: LoginFacebookInteractorType {
    @Injected var loginFacebookProvider: LoginFacebookProvider
    func loginThroughFacebook() -> AnyPublisher<User, Error> {
        loginFacebookProvider.loginThroughtFacebook()
    }
}
