//
//  StoreUserInteractor.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Combine
import RealmSwift

protocol StoreInteractor {
    func saveEntry(entry: Object) -> AnyPublisher<Bool, Error>
    func getEntry<E: Object>() -> AnyPublisher<E?, Error>
    func validateCredentials(email: String,
                             password: String) -> AnyPublisher<Bool, Error>
    func updateUserParams(email: String?,
                          password: String?,
                          dexcomToken: String?) -> AnyPublisher<Bool, Error>
    func logOut() -> AnyPublisher<Bool, Error>
}
