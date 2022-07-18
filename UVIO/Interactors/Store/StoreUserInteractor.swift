//
//  StoreUserInteractor.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Combine
import RealmSwift

protocol StoreInteractor {
    func getEntry<E: Object>() -> AnyPublisher<E?, Error>
    func saveEntry<E: Object>(entry: E) -> AnyPublisher<Bool, Error>
    func updateEntry<T: Object>(_ block: @escaping () -> T) -> AnyPublisher<Bool, Error>
    func getListEntries() -> AnyPublisher<[ListItem], Error>
    func validateCredentials(email: String,
                             password: String) -> AnyPublisher<Bool, Error>
    func logOut() -> AnyPublisher<Bool, Error>
}
