//
//  UserViewModel.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Combine
import Resolver
import SwiftUI

class UserViewModel: ObservableObject {
    @Injected var storeUserInteractor: StoreUserInteractorType
    func getUser() -> AnyPublisher<User, Error>? {
        storeUserInteractor.getUserFromCoreData()
    }
    func save(user: User) -> AnyPublisher<Bool, Error>? {
        storeUserInteractor.saveUserToCoreData(user: user)
    }
 }
