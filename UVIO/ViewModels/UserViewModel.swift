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
    @Published var recoveryEmail: String = ""
    @Published var newPassword: String = ""
    @Published var signUp = false
    @Published var signUpConfirmed = false
    @Published var userWasCreated = false
    private var cancellableSet = Set<AnyCancellable>()
    @Injected var dependency: Dependency
    var facebookPublisher = PassthroughSubject<Void, Error>()
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
        $signUpConfirmed
            .sink { isConfirmed in
                if isConfirmed {
                    _  = self.save(user: User())
                }
            }.store(in: &cancellableSet)
        facebookPublisher
            .flatMap({ _ in self.dependency.provider.facebookLoginService.login() })
            .flatMap(save)
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: \.userWasCreated, on: self)
            .store(in: &cancellableSet)
    }
}
// Handle store user
extension UserViewModel {
    func getUser() -> AnyPublisher<User?, Error> {
        dependency.provider.storeService.getUser()
    }
    func save(user: User) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService.saveUser(user: user)
    }
}
