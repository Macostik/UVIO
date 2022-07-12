//
//  Provider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import UIKit

typealias UserData = (String, String)
typealias ProviderType = FacebookProvider & GoogleProvider & AppleProvider & DexcomProvider  & StoreProvider & APIProvider
let rootViewController: UIViewController = {
    UIApplication.shared.windows.first?.rootViewController ?? UIViewController()
}()
let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero

struct Provider: ProviderType {
    var facebookService: FacebookInteractor = {
        FacebookService()
    }()
    var googleService: GoogleInteractor = {
        GoogleService()
    }()
    var appleService: AppleInteractor = {
        AppleService()
    }()
    var dexcomService: DexcomInteractor = {
        DexcomService()
    }()
    var storeService: StoreInteractor = {
        StoreService()
    }()
    var apiService: APIInteractor = {
        APIService()
    }()
}
