//
//  StoreUserProvider.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Combine
import RealmSwift

enum RealmError: Error {
    case none
}

protocol StoreUserProvider {
    func saveUser(user: User) -> AnyPublisher<Bool, Error>
    func getUser() -> AnyPublisher<User?, Error>
}

class StoreUserService: StoreUserProvider {
    private var realm: Realm? {
         try? Realm()
    }
    init() {
        let configuration = Realm.Configuration.defaultConfiguration
        print(configuration.fileURL ?? "")
        do {
            _ = try Realm.deleteFiles(for: configuration)
        } catch {
            print("Realm wasn't created")
        }
    }
    func saveUser(user: User) -> AnyPublisher<Bool, Error> {
        do {
            try realm?.write {
                realm?.add(user)
            }
        } catch {
            return Just(false)
                .mapError { _ in RealmError.none }
                .eraseToAnyPublisher()
        }
        return Just(true)
            .mapError { _ in RealmError.none }
            .eraseToAnyPublisher()
    }
    func getUser() -> AnyPublisher<User?, Error> {
        guard let user =  realm?.objects(User.self).first else {
            return Just(nil)
                .mapError { _ in RealmError.none }
                .eraseToAnyPublisher()
        }
        return  Just(user)
            .mapError { _ in RealmError.none }
            .eraseToAnyPublisher()
    }
}
