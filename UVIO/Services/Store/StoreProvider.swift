//
//  StoreProvider.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Combine
import RealmSwift

enum RealmError: Error {
    case unknow
}
protocol StoreProvider {
    func saveUser(user: User) -> AnyPublisher<Bool, Error>
    func getUser() -> AnyPublisher<User?, Error>
}

class StoreService: StoreProvider {
    private var realm: Realm? {
         try? Realm()
    }
    init() {
        let configuration = Realm.Configuration.defaultConfiguration
        Logger.debug(configuration.fileURL)
        do {
            _ = try Realm.deleteFiles(for: configuration)
        } catch {
            Logger.error("Realm wasn't created")
        }
    }
    func saveUser(user: User) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        realm?.writeAsync({ [weak self] in
            guard let self = self else {
                Logger.error("User wasn't save")
                return subject.send(completion: .failure(RealmError.unknow))
            }
            self.realm?.add(user)
        }, onComplete: { error in
            guard let error = error else {
                Logger.debug("User was saved successfully")
                subject.send(true)
                return  subject.send(completion: .finished)
            }
            subject.send(completion: .failure(error))
        })
        return subject.eraseToAnyPublisher()
    }
    func getUser() -> AnyPublisher<User?, Error> {
        guard let user =  realm?.objects(User.self).first else {
            return Just(nil)
                .mapError { _ in RealmError.unknow }
                .eraseToAnyPublisher()
        }
        return  Just(user)
            .mapError { _ in RealmError.unknow }
            .eraseToAnyPublisher()
    }
}
