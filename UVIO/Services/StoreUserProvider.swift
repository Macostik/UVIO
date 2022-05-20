//
//  StoreUserProvider.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Combine

enum CoreDataError: Error {
    case none
}

protocol StoreUserProvider {
    func saveUserToCoreData(user: User) -> AnyPublisher<Bool, Error>?
    func getUserFromCoreData() -> AnyPublisher<User, Error>?
}

class StoreUserService: StoreUserProvider {
    func saveUserToCoreData(user: User) -> AnyPublisher<Bool, Error>? {
        Just(false)
            .mapError { _ in CoreDataError.none }
            .eraseToAnyPublisher()
    }
    func getUserFromCoreData() -> AnyPublisher<User, Error>? {
        Just(User())
            .mapError { _ in CoreDataError.none }
            .eraseToAnyPublisher()
    }
}
