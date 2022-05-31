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
    @Injected var dependency: Dependency
    // User name
    @Published var name: String = ""
    // User birthDate
    @Published var birthDate: Date = Date()
    // User gender
    @Published var isSelectedSpecifyType = false
    @Published var ownType: String = ""
    @Published var genderSelectedItem = genderTypeList.first {
        willSet {
            guard let item = newValue else { return }
            genderTypeList.forEach({ $0.isSelected = false })
            let selectedItem = genderTypeList.first(where: { $0.id == item.id })
            if let selectedItem = selectedItem {
                isSelectedSpecifyType = selectedItem.id == 4
                selectedItem.isSelected = true
            }
        }
    }
    // User glucose
    @Published var glucoseRangeValue: ClosedRange<Int> = 100...160
    @Published var hyperValue: Int = 200
    @Published var hypoValue: Int = 70
    @Published var glucoseSelectedItem: GlucoseType? {
        willSet {
            guard let item = newValue else { return }
            glucoseTypeList.forEach({ $0.isSelected = false })
            glucoseTypeList.first(where: { $0.id == item.id })?.isSelected = true
        }
    }
    // User diabet
    @Published var diabetSelectedItem = diabetTypeList.first {
        willSet {
            guard let item = newValue else { return }
            diabetTypeList.forEach({ $0.isSelected = false })
            diabetTypeList.first(where: { $0.id == item.id })?.isSelected = true
        }
    }
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var recoveryEmail: String = ""
    @Published var newPassword: String = ""
    @Published var signUp = false
    @Published var signUpConfirmed = false
    @Published var userWasUpdated = false
    @Published var userPersist = false
    @Published var userCreateCompleted = false
    @Published var showErrorAlert: Bool = false
    var signInClickPublisher = PassthroughSubject<Void, Error>()
    var signUpClickPublisher = PassthroughSubject<Void, Error>()
    var createNewUser = PassthroughSubject<User, Error>()
    private var cancellableSet = Set<AnyCancellable>()
    var facebookPublisher = PassthroughSubject<Void, Error>()
    var googlePublisher = PassthroughSubject<Void, Error>()
    init() {
        createUser()
        checkUser()
        handleLoginViaThirdParty()
        validateCredintials()
        fillUserCredentials()
//        handleSignIn()
        handleSignUp()
    }
}
// Init
extension UserViewModel {
    func validateCredintials() {
        isComfirmedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.signUp, on: self)
            .store(in: &cancellableSet)
    }
    func fillUserCredentials() {
        $signUpConfirmed
            .dropFirst()
            .map({ isConfirm in
                self.showErrorAlert = !isConfirm
                return isConfirm
            })
            .filter({ $0 })
            .sink { _ in
                _ = self.setupCredentials(email: self.email, password: self.password)
            }.store(in: &cancellableSet)
    }
    func handleLoginViaThirdParty() {
        let facebookPublisher =
        facebookPublisher
            .flatMap({ _ in self.dependency.provider.facebookLoginService.login() })
        let googlePublisher =
        googlePublisher
            .flatMap({ _ in self.dependency.provider.googleLoginService.login() })
        Publishers.MergeMany(facebookPublisher, googlePublisher)
            .flatMap(save)
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .assign(to: \.userWasUpdated, on: self)
            .store(in: &cancellableSet)
    }
    func checkUser() {
        getUser()
            .map({ user in
                guard let user = user else { return false }
                return user.isLogin
            })
            .replaceError(with: false)
            .assign(to: \.userPersist, on: self)
            .store(in: &cancellableSet)
    }
    func createUser() {
        createNewUser
            .map { user -> User in
                user.id = UUID().uuidString
                user.name = self.name
                user.birthDate = self.birthDate
                user.gender = self.genderSelectedItem?.type ?? ""
                user.diabetsType = self.diabetSelectedItem?.type ?? ""
                user.glucoseUnit = self.glucoseUnit
                user.glucoseTargetLowerBound = "\(self.glucoseRangeValue.lowerBound)"
                user.glucoseTargetUpperBound = "\(self.glucoseRangeValue.upperBound)"
                user.hypo = "\(self.hypoValue)"
                user.hyper = "\(self.hyperValue)"
                return user
            }
            .flatMap(save)
            .assertNoFailure()
            .assign(to: \.userCreateCompleted, on: self)
            .store(in: &cancellableSet)
    }
    func handleSignIn() {
        signInClickPublisher
            .flatMap({ _ in self.validateCredentials(email: self.email, password: self.password) })
            .assertNoFailure()
            .assign(to: \.signUpConfirmed, on: self)
            .store(in: &cancellableSet)
    }
    func handleSignUp() {
        signUpClickPublisher
            .map({ self.signUp })
            .assertNoFailure()
            .assign(to: \.signUpConfirmed, on: self)
            .store(in: &cancellableSet)
    }
}
// Handle publishers
extension UserViewModel {
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
}
// Handle store user
extension UserViewModel {
    func getUser() -> AnyPublisher<User?, Error> {
        dependency.provider.storeService.getUser()
    }
    func setupCredentials(email: String,
                          password: String) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService
            .setupCredentionals(email: email,
                                password: password)
    }
    func save(user: User) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService.save(user: user)
    }
    func validateCredentials(email: String,
                             password: String) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService
            .validateCredentials(email: email, password: password)
    }
    func logOut() -> AnyPublisher<Bool, Error> {
        dependency.provider.storeService.logOut()
    }
}
// Handle user data converting
extension UserViewModel {
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    var birthDateString: String {
        dateFormatter.string(from: birthDate)
    }
    var glucoseUnit: String {
        glucoseSelectedItem?.type ?? L10n.mgDL
    }
}

// Handle onboarding views
extension UserViewModel {
    func buildView(types: [Any], index: Int) -> AnyView {
        switch types[index].self {
        case is NameOnboardingView.Type: return AnyView( NameOnboardingView(viewModel: self) )
        case is BirthDateOnboardingView.Type: return AnyView( BirthDateOnboardingView(viewModel: self) )
        case is GenderOnboardingView.Type: return AnyView( GenderOnboardingView(viewModel: self) )
        case is GlucoseUnitOnboardingView.Type: return AnyView( GlucoseUnitOnboardingView(viewModel: self) )
        default: return AnyView(EmptyView())
        }
    }
}
