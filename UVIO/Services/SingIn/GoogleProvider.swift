//
//  GoogleProvider.swift
//  UVIO
//
//  Created by Macostik on 25.05.2022.
//

import Combine
import GoogleSignIn
import RealmSwift

protocol GoogleProvider {
    var googleService: GoogleInteractor { get }
}

struct GoogleService: GoogleInteractor {
    let loginManager = GIDSignIn.sharedInstance
    func getBearer() -> AnyPublisher<Token?, Error> {
        loginManager.authorizePublisher()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
