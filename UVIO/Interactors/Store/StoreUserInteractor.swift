//
//  StoreUserInteractor.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Resolver
import Combine

protocol StoreInteractor {
    func saveUser(user: User) -> AnyPublisher<Bool, Error>
    func getUser() -> AnyPublisher<User?, Error>
    func setupCredentionals(email: String?, password: String) -> AnyPublisher<Bool, Error>
    func validateCredentials(email: String, password: String) -> Bool
    func logOut()
}
