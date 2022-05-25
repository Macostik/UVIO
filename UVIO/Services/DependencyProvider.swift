//
//  DependencyProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Foundation
import Resolver

protocol DependencyProvider {
    var authService: AuthService { get set }
    var storeService: StoreService { get set }
}

struct Dependency: DependencyProvider {
    @Injected var authService: AuthService
    @Injected var storeService: StoreService
}
