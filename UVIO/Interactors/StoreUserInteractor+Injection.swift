//
//  StoreUserInteractor+Injection.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Resolver

extension Resolver {
    public static func registerUserStore() {
        register(StoreUserInteractorType.self) { _ in
            return StoreUserInteractor()
        }
    }
}




