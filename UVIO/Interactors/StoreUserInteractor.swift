//
//  StoreUserInteractor.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Resolver
import Combine

protocol StoreUserInteractorType {
    func saveUser(user: User) -> AnyPublisher<Bool, Error>?
    func getUser() -> AnyPublisher<User, Error>?
}

class StoreUserInteractor: StoreUserInteractorType {
    @Injected var provider: StoreUserProvider
    func saveUser(user: User) -> AnyPublisher<Bool, Error>? {
        provider.saveUser(user: user)
    }
    func getUser() -> AnyPublisher<User, Error>? {
        provider.getUser()
    }
}
