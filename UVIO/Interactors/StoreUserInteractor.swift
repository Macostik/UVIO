//
//  StoreUserInteractor.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Resolver
import Combine

protocol StoreUserInteractorType {
    func saveUserToCoreData(user: User) -> AnyPublisher<Bool, Error>?
    func getUserFromCoreData() -> AnyPublisher<User, Error>?
}

class StoreUserInteractor: StoreUserInteractorType {
    @Injected var provider: StoreUserProvider
    func saveUserToCoreData(user: User) -> AnyPublisher<Bool, Error>? {
        provider.saveUserToCoreData(user: user)
    }
    func getUserFromCoreData() -> AnyPublisher<User, Error>? {
        provider.getUserFromCoreData()
    }
}
