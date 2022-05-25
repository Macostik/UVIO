//
//  LoginGoogleProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation

protocol LoginGoogleProvider {
    var googleLoginService: LoginGoogleInteractor { get }
}

struct LoginGoogleService: LoginGoogleInteractor {
    func login() {}
}
