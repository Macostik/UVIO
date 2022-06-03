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
    @Published var ownType: String = ""
    @Published var genderSelectedItem: GenderType? {
        willSet {
            guard let item = newValue else { return }
            genderTypeList.forEach({ $0.isSelected = false })
            let selectedItem = genderTypeList.first(where: { $0.id == item.id })
            if let selectedItem = selectedItem {
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
    // Onboarding selection
    @Published var selectedItem: OnboardingViewType = .name
    // Onboarding alert
    @Published var isVibrate: Bool = false
    @Published var isNotDisturb: Bool = false
    // Dexcome data
    @Published var dexcomToken: String = "" {
        didSet {
            if !dexcomToken.isEmpty {
                createNewUser.send(User())
            }
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
    var presentOnboardingView =  CurrentValueSubject<OnboardingViewType, Error>(.name)
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
        handleSignUp()
        handleOnboardingScreen()
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
            .map({ name, email -> Bool in
                self.name = name
                self.email = email
                return true
            })
            .replaceError(with: false)
            .assign(to: \.signUpConfirmed, on: self)
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
                user.email = self.email
                user.password = self.password
                user.birthDate = self.birthDate
                user.gender = self.genderSelectedItem?.type ?? ""
                user.diabetsType = self.diabetSelectedItem?.type ?? ""
                user.glucoseUnit = self.glucoseUnit
                user.glucoseTargetLowerBound = "\(self.glucoseRangeValue.lowerBound)"
                user.glucoseTargetUpperBound = "\(self.glucoseRangeValue.upperBound)"
                user.hypo = "\(self.hypoValue)"
                user.hyper = "\(self.hyperValue)"
                user.isVibrate = self.isVibrate
                user.isNotDisturb = self.isNotDisturb
                user.dexcomToken = self.dexcomToken
                return user
            }
            .flatMap(save)
            .replaceError(with: false)
            .assign(to: \.userCreateCompleted, on: self)
            .store(in: &cancellableSet)
    }
    func handleSignIn() {
        signInClickPublisher
            .flatMap({ _ in self.validateCredentials(email: self.email, password: self.password) })
            .replaceError(with: false)
            .assign(to: \.signUpConfirmed, on: self)
            .store(in: &cancellableSet)
    }
    func handleSignUp() {
        signUpClickPublisher
            .map({ self.signUp })
            .replaceError(with: false)
            .assign(to: \.signUpConfirmed, on: self)
            .store(in: &cancellableSet)
    }
    func handleOnboardingScreen() {
        presentOnboardingView
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { type in
                withAnimation {
                    self.selectedItem = type
                }
            }
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
    func updateUserParams(email: String? = nil,
                          password: String? = nil,
                          dexcomToken: String? = nil) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService
            .updateUserParams(email: email,
                              password: password,
                              dexcomToken: dexcomToken)
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
// Handle onboarding
extension UserViewModel {
    var completionValue: CGFloat {
        switch selectedItem {
        case .name:  return 0.2
        case .birthDate: return 0.4
        case .gender: return 0.6
        case .glucoseUnit: return 0.8
        case .glucoseAlert: return 1.0
        }
    }
    var previousType: OnboardingViewType {
        switch selectedItem {
        case .name: return .name
        case .birthDate: return .name
        case .gender: return .birthDate
        case .glucoseUnit: return .gender
        case .glucoseAlert: return .glucoseUnit
        }
    }
}
// Handle dexcom API
extension UserViewModel {
    func dexcomLogin() {
        dependency.provider.dexcomService.getBearer()
            .replaceError(with: "")
            .assign(to: \.dexcomToken, on: self)
            .store(in: &cancellableSet)
    }
}
