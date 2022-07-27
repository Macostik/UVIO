//
//  BaseViewModel.swift
//  UVIO
//
//  Created by Macostik on 20.07.2022.
//

import Combine
import SwiftUI
import RealmSwift
import Alamofire

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var signInConfirmed = false
    @Published var signUpConfirmed = false {
        willSet {
            if newValue {
                self.presentOnboardingView.value = .name
            }
        }
    }
    @Published var hasUserlogOut = false {
        willSet {
            self.signInConfirmed = !newValue
            self.signUpConfirmed = !newValue
        }
    }
    var presentOnboardingView =  CurrentValueSubject<OnboardingViewType, Error>(.singUp)
    var cancellableSet = Set<AnyCancellable>()
    @Environment(\.dependency) var dependency
    init() {
        if user == nil {
            handleGettinguser()
        }
    }
    var isUserInvalidated: Bool {
        return !(user?.isInvalidated ?? true)
    }
    var userName: String {
        if isUserInvalidated, let user = user {
           return user.name
        }
        return ""
    }
    func handleGettinguser() {
        getUser()
            .replaceError(with: nil)
            .assign(to: \.user, on: self)
            .store(in: &cancellableSet)
    }
    func logOutUser() {
        logOut()
            .replaceError(with: false)
            .assign(to: \.hasUserlogOut, on: self)
            .store(in: &cancellableSet)
    }
    //    func checkUser() {
    //        $user
    //            .map { $0?.isLogin }
    //            .replaceNil(with: false)
    //            .assign(to: \.userPersist, on: self)
    //            .store(in: &cancellableSet)
    //    }
}

// Handle store user
extension BaseViewModel {
    func getUser() -> AnyPublisher<User?, Error> {
        dependency.provider.storeService.getEntry()
    }
    func save(entry: Object) -> AnyPublisher<Bool, Error> {
        user = entry as? User
        return dependency.provider.storeService.saveEntry(entry: entry)
    }
    func updateEntry<T: Object>(_ entry: @escaping () -> T) -> AnyPublisher<Bool, Error> {
        dependency.provider.storeService.updateEntry(entry)
    }
    func logOut() -> AnyPublisher<Bool, Error> {
        dependency.provider.storeService.logOut()
    }
}
// Handle third party login
extension UserViewModel {
    func dexcomLogin() {
        dependency.provider.dexcomService.getBearer()
            .replaceError(with: "")
            .assign(to: \.dexcomToken, on: self)
            .store(in: &cancellableSet)
    }
    func registerUser() {
        dependency.provider.apiService
            .register(name: name,
                   email: email,
                      password: password.isEmpty ? "password" : password,
                   birthDate: birthDateParam,
                   gender: genderSelectedItem?.type ?? "" )
            .sink(receiveCompletion: { _ in
            }, receiveValue: { response in
                guard let response = response.value,
                        response.success else {
                    Logger.error("Something went wrong: \(String(describing: response.error))")
                    return
                }
                let user = response.data.user
                self.authToken = response.data.token
                self.createNewUser.send(user)
            })
            .store(in: &cancellableSet)
    }
    func login() -> AnyPublisher<Bool, Error> {
        if loginMode == .signIn {
            return dependency.provider.apiService
                .login(email: email, password: password)
                .flatMap({ response -> AnyPublisher<Bool, Error> in
                    guard let response = response.value
                    else {
                        Logger.error("Something went wrong: \(String(describing: response.error))")
                        return Just(false)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                    let user = response.data.user
                    self.authToken = response.data.token
                    self.createNewUser.send(user)
                    return Just(response.success)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
        }
        return Just(true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    func socialLogin(with socialType: SocialValueType) {
        dependency.provider.apiService
            .socialLogin(name: socialType.name,
                         email: socialType.email,
                         token: socialType.token,
                         platform: socialType.platform)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { response in
                guard let response = response.value,
                        response.success else {
                    Logger.error("Something went wrong: \(String(describing: response.error))")
                    return
                }
                let user = response.data.user
                self.authToken = response.data.token
                self.createNewUser.send(user)
            })
            .store(in: &cancellableSet)
    }
    func appleLogin() {
        dependency.provider.appleService.singIn()
            .map({ [unowned self] value in
                let authorized = value == .authorized
                self.signUp = authorized
                return authorized
            })
            .replaceError(with: false)
            .assign(to: \.isloginModeSignUp, on: self)
            .store(in: &cancellableSet)
    }
    func facebookLogin() {
        dependency.provider.facebookService.getData()
            .compactMap({ $0 })
            .sink { _ in
            } receiveValue: { [unowned self] value in
                self.socialLogin(with: value)
            }
            .store(in: &cancellableSet)
    }
    func googleLogin() {
        dependency.provider.googleService.getData()
            .compactMap({ $0 })
            .sink { _ in
            } receiveValue: { [unowned self] value in
                self.socialLogin(with: value)
            }
            .store(in: &cancellableSet)
    }
}
