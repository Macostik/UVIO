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
    func saveUser(user: User) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        let realm = RealmProvider.shared.realm
        realm.writeAsync({
            Logger.debug("User is writing to DB")
            realm.add(user, update: .modified)
        }, onComplete: { error in
            guard let error = error else {
                Logger.debug("User was saved successfully")
                subject.send(true)
                return  subject.send(completion: .finished)
            }
            Logger.error("User wasn't saved to DB with error: \(error)")
            subject.send(completion: .failure(error))
        })
        return subject.eraseToAnyPublisher()
    }
    func updateCredentionals(email: String, password: String) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        let realm = RealmProvider.shared.realm
        guard let currentUser = realm.objects(User.self).first else {
            Logger.error("Realm doesn't contain user")
            subject.send(completion: .failure(RealmError.empty))
            return subject.eraseToAnyPublisher()
        }
        realm.writeAsync({
            Logger.debug("User is updating to DB")
            currentUser.email = email
            currentUser.password = password
            realm.add(currentUser, update: .modified)
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
    func getUser() -> AnyPublisher<User?, Error> {
        let realm = RealmProvider.shared.realm
        guard let user = realm.objects(User.self).first else {
            return Just(nil)
                .mapError { _ in RealmError.unknow }
                .eraseToAnyPublisher()
        }
        return  Just(user)
            .mapError { _ in RealmError.unknow }
            .eraseToAnyPublisher()
    }
}
