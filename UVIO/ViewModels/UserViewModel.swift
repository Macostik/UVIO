//
//  UserViewModel.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Combine
import SwiftUI
import RealmSwift

class UserViewModel: ObservableObject {
    enum LoginMode {
        case signUp, signIn
    }
    @Environment(\.dependency) var dependency
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
    @Published var selectedOnboardingItem: OnboardingViewType = .singUp
    // Login  selection
    @Published var selectedLoginItem: LoginViewType = .signIn
    // Onboarding alert
    @Published var isVibrate: Bool = false
    @Published var isNotDisturb: Bool = false
    @Published var notifyBGLevelOutOfRange: Bool = false
    @Published var alertBGLevelOutOfRange: Bool = false
    // Facebook token
    @Published var authToken: String = "" {
        willSet {
            if !newValue.isEmpty {
                Logger.info("Login was successful with auth token: \(newValue)")
                signUp = true
                isloginModeSignUp = true
            }
        }
    }
    // Dexcome data
    @Published var dexcomToken: String = "" {
        didSet {
            if !dexcomToken.isEmpty {
                createNewUser.send(User())
            }
        }
    }
    // Handle login mode
    @Published var loginMode = LoginMode.signUp
    @Published var isloginModeSignUp: Bool = false {
        willSet {
            self.showErrorAlert = !newValue
            if newValue {
                switch loginMode {
                case .signUp: self.signUpConfirmed = signUp
                case .signIn: self.signInConfirmed = signUp
                }
            }
        }
    }
    @Published var signUpConfirmed = false {
        willSet {
            if newValue {
                self.presentOnboardingView.value = .name
            }
        }
    }
    @Published var signInConfirmed = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var recoveryEmail: String = ""
    @Published var newPassword: String = ""
    @Published var signUp = false
    @Published var userWasUpdated = false
    @Published var userPersist = false
    @Published var userCreateCompleted = false
    @Published var showErrorAlert: Bool = false
    var presentOnboardingView =  CurrentValueSubject<OnboardingViewType, Error>(.singUp)
    var presentLoginView =  CurrentValueSubject<LoginViewType, Error>(.signIn)
    var signUpClickPublisher = PassthroughSubject<Void, Error>()
    var createNewUser = PassthroughSubject<User, Error>()
    private var cancellableSet = Set<AnyCancellable>()
    init() {
        createUser()
        checkUser()
        validateCredintials()
        fillUserCredentials()
        handleSignUp()
        handleOnboardingScreen()
        handleLoginScreen()
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
            .filter({ $0 })
            .sink { _ in
            }.store(in: &cancellableSet)
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
                user.authToken = self.authToken
                user.dexcomToken = self.dexcomToken
                return user
            }
            .flatMap(save)
            .replaceError(with: false)
            .assign(to: \.userCreateCompleted, on: self)
            .store(in: &cancellableSet)
    }
    func handleSignUp() {
        signUpClickPublisher
            .map({ self.signUp })
            .flatMap({ _ in self.validateCredentials(email: self.email, password: self.password) })
            .replaceError(with: false)
            .assign(to: \.isloginModeSignUp, on: self)
            .store(in: &cancellableSet)
    }
    func handleOnboardingScreen() {
        presentOnboardingView
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { type in
                withAnimation {
                    self.selectedOnboardingItem = type
                }
            }
            .store(in: &cancellableSet)
    }
    func handleLoginScreen() {
        presentLoginView
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { type in
                withAnimation {
                    self.selectedLoginItem = type
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
        dependency.provider.storeService.getEntry()
    }
    func updateUserParams(email: String? = nil,
                          password: String? = nil,
                          dexcomToken: String? = nil) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService
            .updateUserParams(email: email,
                              password: password,
                              dexcomToken: dexcomToken)
    }
    func save(entry: Object) -> AnyPublisher<Bool, Error> {
        return dependency.provider.storeService.saveEntry(entry: entry)
    }
    func validateCredentials(email: String,
                             password: String) -> AnyPublisher<Bool, Error> {
        if loginMode == .signIn {
            return dependency.provider.storeService
                .validateCredentials(email: email, password: password)
        }
        return Just(signUp)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
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
        switch selectedOnboardingItem {
        case .singUp: return 0.0
        case .emailSignUp: return 0.0
        case .name:  return 0.2
        case .birthDate: return 0.4
        case .gender: return 0.6
        case .glucoseUnit: return 0.8
        case .glucoseAlert: return 1.0
        }
    }
    var previousOnboardingType: OnboardingViewType {
        switch selectedOnboardingItem {
        case .singUp: return .singUp
        case .emailSignUp: return .singUp
        case .name: return .emailSignUp
        case .birthDate: return .name
        case .gender: return .birthDate
        case .glucoseUnit: return .gender
        case .glucoseAlert: return .glucoseUnit
        }
    }
    var previousLoginType: LoginViewType {
        switch selectedLoginItem {
        case .signIn: return .signIn
        case .emailSignUp: return .signIn
        case .recoveryEmail: return .emailSignUp
        case .checkInBox: return .recoveryEmail
        case .newPassword: return .checkInBox
        case .newPasswordSuccess: return .newPassword
        }
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
    func appleLogin() {
        dependency.provider.appleService.singIn()
            .map({ $0 == .authorized })
            .replaceError(with: false)
            .assign(to: \.isloginModeSignUp, on: self)
            .store(in: &cancellableSet)
    }
    func facebookLogin() {
        dependency.provider.facebookService.getBearer()
            .replaceError(with: "")
            .compactMap({ $0 })
            .assign(to: \.authToken, on: self)
            .store(in: &cancellableSet)
    }
    func googleLogin() {
        dependency.provider.googleService.getBearer()
            .replaceError(with: "")
            .compactMap({ $0 })
            .assign(to: \.authToken, on: self)
            .store(in: &cancellableSet)
    }
}
