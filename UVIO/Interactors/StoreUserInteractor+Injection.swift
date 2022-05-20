//
//  StoreUserInteractor+Injection.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Resolver

extension Resolver {
    public static func registerUserStore() {
        register(StoreUserInteractorType.self) {
            StoreUserInteractor()
        }
        register(StoreUserProvider.self) {
            StoreUserService()
        }
    }
}
