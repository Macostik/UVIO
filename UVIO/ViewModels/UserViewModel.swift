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
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var signUp = false
    @Published var signUpConfirmed = false
    private var cancellableSet = Set<AnyCancellable>()
    @Injected var storeUserInteractor: StoreUserInteractorType
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { $0.count > 5}
            .eraseToAnyPublisher()
    }
    private var isEmailValid: AnyPublisher<Bool, Never> {
        $email
            .map({ $0.isValidEmail() })
            .eraseToAnyPublisher()
    }
    private var isComfirmedPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValid, isPasswordEmptyPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    init() {
        isComfirmedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.signUp, on: self)
            .store(in: &cancellableSet)
    }
    func getUser() -> AnyPublisher<User, Error>? {
        storeUserInteractor.getUserFromCoreData()
    }
    func save(user: User) -> AnyPublisher<Bool, Error>? {
        storeUserInteractor.saveUserToCoreData(user: user)
    }
 }
