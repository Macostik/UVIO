//
//  RealmProvider.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import Foundation
import RealmSwift
import Realm

struct RealmProvider {
  private let configuration: Realm.Configuration

  internal init(config: Realm.Configuration) {
      configuration = config
      Logger.info("\(configuration.fileURL!)")
  }
  public var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            Logger.error("Realm was not configured!")
            fatalError()
        }
    }
//    private static func configureRealm() -> Realm.Configuration {
//        var config = Realm.Configuration.defaultConfiguration
//        var groupURL = config.fileURL?
//            .deletingLastPathComponent().appendingPathComponent("\(EnvironmentProvider.ENV).realm")
//        guard let url = FileManager.default
//            .containerURL(forSecurityApplicationGroupIdentifier: Constant.groupId) else {
//            return config
//        }
//        groupURL = url.appendingPathComponent("\(EnvironmentProvider.ENV).realm")
//        let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL
//        if realmFileURL?.absoluteString != groupURL?.absoluteString {
//            config.fileURL = groupURL
//            config.schemaVersion = 1
//            config.migrationBlock = { _, oldSchemaVersion in
//                if oldSchemaVersion < 1 {
//                    Logger.debug("Migration")
//                }
//            }
//        }
//        Realm.Configuration.defaultConfiguration = config
//        if let realmFileURL = config.fileURL {
//            Logger.info("\(realmFileURL)")
//        }
//        return config
//    }
    public static var shared = RealmProvider(config: .defaultConfiguration)
}
