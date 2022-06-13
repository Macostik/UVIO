//
//  StoreProvider.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Combine
import RealmSwift

enum RealmError: Error {
    case unknow, empty
}
protocol StoreProvider {
    var storeService: StoreInteractor { get }
}

class StoreService: StoreInteractor {
    let realmProvider = RealmProvider(config: .defaultConfiguration)
    func save(user: User) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        let realm = realmProvider.realm
        realm?.writeAsync({
            guard  let users = realm?.objects(User.self) else {
                Logger.error("Realm doesn't contain user")
                subject.send(completion: .failure(RealmError.unknow))
                return
            }
            realm?.delete(users)
            Logger.debug("User is writing to DB")
            realm?.add(user, update: .modified)
        }, onComplete: { error in
            guard let error = error else {
                Logger.debug("User was saved successfully")
                subject.send(true)
                return subject.send(completion: .finished)
            }
            Logger.error("User wasn't saved to DB with error: \(error)")
            subject.send(completion: .failure(error))
        })
        return subject.eraseToAnyPublisher()
    }
    func getUser() -> AnyPublisher<User?, Error> {
        let realm = realmProvider.realm
        guard let user = realm?.objects(User.self).first else {
            return Just(nil)
                .mapError { _ in RealmError.unknow }
                .eraseToAnyPublisher()
        }
        return  Just(user)
            .mapError { _ in RealmError.unknow }
            .eraseToAnyPublisher()
    }
    func updateUserParams(email: String? = nil,
                          password: String? = nil,
                          dexcomToken: String? = nil) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        let realm = realmProvider.realm
        guard let currentUser = realm?.objects(User.self).first else {
            Logger.error("Realm doesn't contain user")
            subject.send(completion: .failure(RealmError.empty))
            return subject.eraseToAnyPublisher()
        }
        realm?.writeAsync({
            Logger.debug("User is updating to DB")
            if let email = email {
                currentUser.email = email
            }
            if let password = password {
                currentUser.password = password
            }
            if let dexcomToken = dexcomToken {
                currentUser.dexcomToken = dexcomToken
            }
            realm?.add(currentUser, update: .modified)
        }, onComplete: { error in
            guard let error = error else {
                Logger.debug("User credentials were saved successfully")
                subject.send(true)
                return  subject.send(completion: .finished)
            }
            Logger.error("User wasn't update to DB with error: \(error)")
            subject.send(completion: .failure(error))
        })
        return subject.eraseToAnyPublisher()
    }
    func validateCredentials(email: String, password: String) -> AnyPublisher<Bool, Error> {
        let subject = CurrentValueSubject<Bool, Error>(false)
        let realm = realmProvider.realm
        guard let currentUser = realm?.objects(User.self).first else {
            Logger.error("Realm doesn't contain user")
            return subject.eraseToAnyPublisher()
        }
        let isValidate = currentUser.email == email && currentUser.password == password
        if !isValidate {
            Logger.info("Credentials were not matched")
        }
        subject.send(isValidate)
        return subject.eraseToAnyPublisher()
    }
    func logOut() -> AnyPublisher<Bool, Error> {
        let subject = CurrentValueSubject<Bool, Error>(false)
        let realm = realmProvider.realm
        guard let currentUser = realm?.objects(User.self).first else {
            Logger.error("Realm doesn't contain user")
            return subject.eraseToAnyPublisher()
        }
        realm?.writeAsync({
            currentUser.isLogin = false
        }, onComplete: { error in
            guard let error = error else {
                Logger.debug("User was log out successfully")
                subject.send(true)
                subject.send(completion: .finished)
                return
            }
            subject.send(completion: .failure(error))
            Logger.error("User wasn't log out with error: \(error)")
        })
        return subject.eraseToAnyPublisher()
    }
}
