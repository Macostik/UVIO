//
//  Provider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Resolver
import UIKit

typealias UserData = (String, String)
typealias ProviderType = FacebookProvider & GoogleProvider & AppleProvider & DexcomProvider  & StoreProvider
let rootViewController: UIViewController = {
    UIApplication.shared.windows.first?.rootViewController ?? UIViewController()
}()

struct Provider: ProviderType {
    var facebookService: FacebookInteractor {
        FacebookService()
    }
    var googleService: GoogleInteractor {
        GoogleService()
    }
    var appleService: AppleInteractor {
        AppleService()
    }
    var dexcomService: DexcomInteractor {
        DexcomService()
    }
    var storeService: StoreInteractor {
        StoreService()
    }
}
