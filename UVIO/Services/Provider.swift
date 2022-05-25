//
//  Provider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Resolver

typealias ProviderType = LoginFacebookProvider & LoginGoogleProvider & StoreProvider

struct Provider: ProviderType {
    var facebookLoginService: LoginFacebookInteractor {
        LoginFacebookService()
    }
    var googleLoginService: LoginGoogleInteractor {
        LoginGoogleService()
    }
    var storeService: StoreInteractor {
        StoreService()
    }
}
