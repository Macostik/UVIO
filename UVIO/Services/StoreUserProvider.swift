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
    func saveUser(user: User) -> AnyPublisher<Bool, Error>?
    func getUser() -> AnyPublisher<User, Error>?
}

class StoreUserService: StoreUserProvider {
    func saveUser(user: User) -> AnyPublisher<Bool, Error>? {
        Just(false)
            .mapError { _ in CoreDataError.none }
            .eraseToAnyPublisher()
    }
    func getUser() -> AnyPublisher<User, Error>? {
        Just(User())
            .mapError { _ in CoreDataError.none }
            .eraseToAnyPublisher()
    }
}
