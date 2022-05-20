//
//  UVIO+Resolver.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerUserStore()
        register { UserViewModel() }
    }
}
