//
//  StoreProvider.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import Combine
import RealmSwift
import Foundation

enum RealmError: Error {
    case unknow, empty
}
protocol StoreProvider {
    var storeService: StoreInteractor { get }
}

class StoreService: StoreInteractor {
    let realmProvider = RealmProvider(config: .defaultConfiguration)
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
        realm?.writeAsync({
            realm?.deleteAll()
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
    func getEntry<E: Object>() -> AnyPublisher<E?, Error> {
        let realm = realmProvider.realm
        guard let entry = realm?.objects(E.self).first else {
            Logger.debug("Entry wasn't created to DB")
            return Just(nil)
                .mapError { _ in RealmError.unknow }
                .eraseToAnyPublisher()
        }
        Logger.debug("Entry was found: \(entry.description)")
        return Just(entry)
            .mapError { _ in RealmError.unknow }
            .eraseToAnyPublisher()
    }
    func saveEntry<E: Object>(entry: E) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        let realm = realmProvider.realm
        realm?.writeAsync({
            Logger.debug("Entry is writing to DB:\n \(entry)")
            realm?.add(entry, update: .modified)
        }, onComplete: { error in
            guard let error = error else {
                Logger.info("Entry was saved successfully")
                subject.send(true)
                return subject.send(completion: .finished)
            }
            Logger.error("Entry wasn't saved to DB with error: \(error)")
            subject.send(completion: .failure(error))
        })
        return subject.eraseToAnyPublisher()
    }
    func updateEntry<T: Object>(_ block: @escaping () -> T) -> AnyPublisher<Bool, Error> {
        let subject = PassthroughSubject<Bool, Error>()
        let realm = realmProvider.realm
        realm?.writeAsync({
            let entry = block()
            Logger.debug("Entry is updating to DB:\n \(entry)")
            realm?.add(entry, update: .modified)
        }, onComplete: { error in
            guard let error = error else {
                Logger.info("Entry was updated successfully")
                subject.send(true)
                return subject.send(completion: .finished)
            }
            Logger.error("Entry wasn't updated to DB with error: \(error)")
            subject.send(completion: .failure(error))
        })
        return subject.eraseToAnyPublisher()
    }
    func getListEntries() -> AnyPublisher<[ListItem], Error> {
        let subject = CurrentValueSubject<[ListItem], Error>([])
        let realm = realmProvider.realm
        var listViewEntryList = [ListViewEntry]()
        var itemList = [ListItem]()
        for item in MenuAction.allCases {
            if let result = realm?.objects(item.type), !result.isEmpty {
                let entries = result.compactMap({ ($0 as? Mapable)?.map() })
                listViewEntryList.append(contentsOf: entries)
            }
        }
        let groupEntries = Dictionary(grouping: listViewEntryList,
                                               by: { item in item.createdAt })
        for (index, key) in groupEntries.keys.sorted().enumerated() {
            let objects = groupEntries[key]?.sorted(by: {$0.addedAt < $1.addedAt})
            itemList.append(ListItem(index: index,
                                     keyObject: key,
                                     valueObjects: objects!))
        }
        subject.value = itemList
        return subject.eraseToAnyPublisher()
    }
}

extension RealmProvider {
    func authorizePublisher() -> EntryPublisher {
        return EntryPublisher(provider: self)
    }
    struct EntryPublisher: Publisher {
        // swiftlint:disable nesting
        typealias Output = Object
        typealias Failure = Error
        private let provider: RealmProvider
        fileprivate init(provider: RealmProvider) {
            self.provider = provider
        }
        func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = EntrySubscription(provider: provider, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.getEntry(entry: Output.self, provider: provider)
        }
    }
    private class EntrySubscription<S: Subscriber>: Subscription
    where S.Input == Object, S.Failure == Error {
        private let provider: RealmProvider
        private var subscriber: S?
        init(provider: RealmProvider, subscriber: S) {
            self.provider = provider
            self.subscriber = subscriber
        }
        func getEntry(entry: Object.Type, provider: RealmProvider) {
           let realm = provider.realm
            guard let entry = realm?.objects(entry).first else {
                Logger.error("Realm doesn't contain user")
                _ = self.subscriber?.receive(completion: Subscribers.Completion.failure(RealmError.empty))
                return
            }
            _ = self.subscriber?.receive(entry)
        }
        func request(_ demand: Subscribers.Demand) {}
        func cancel() {
            subscriber = nil
        }
    }
}

extension MenuAction {
    var type: Object.Type {
        switch self {
        case .logBG: return LogBGEntry.self
        case .food: return FoodEntry.self
        case .reminder: return ReminderEntry.self
        case .insulin: return InsulinEntry.self
        }
    }
}
