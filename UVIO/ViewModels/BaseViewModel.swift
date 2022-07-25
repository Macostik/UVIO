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
