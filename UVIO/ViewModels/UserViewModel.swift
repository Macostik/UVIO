//
//  UserViewModel.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Combine
import SwiftUI
import RealmSwift
import Alamofire

protocol UserViewModelProvider {
    var userViewModel: BaseViewModel { get }
}

class UserViewModel: BaseViewModel {
    enum LoginMode {
        case signUp, signIn
    }
    // User name
    @Published var userID: String = ""
    @Published var unitsSelectedItem: UnitsType? {
        willSet {
            guard let item = newValue else { return }
            unitsList.forEach({ $0.isSelected = false })
            unitsList.first(where: { $0.id == item.id })?.isSelected = true
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
    // Onboarding alert
    @Published var notifyBGLevelOutOfRange: Bool = false
    @Published var alertBGLevelOutOfRange: Bool = false
    @Published var saveSettings = false
    // Facebook token
    @Published var authToken: String = "" {
        willSet {
            if !newValue.isEmpty {
                Logger.info("Login was successful with auth token: \(newValue)")
                UserDefaults.standard.set(newValue, forKey: Constant.authTokenKey)
                signUp = true
                isloginModeSignUp = true
                isUserlogOut = true
                presentLoginView.value = .signIn
                presentOnboardingView.value = .signUp
            }
        }
    }
    // Dexcome data
    @Published var dexcomToken = DexcomToken(oauthToken: "",
                                             oauthRefreshToken: "") {
        didSet {
            if !dexcomToken.oauthToken.isEmpty {
                registerUser()
            }
        }
    }
    // Handle login mode
    @Published var loginMode = LoginMode.signUp
    @Published var isloginModeSignUp: Bool = false {
        willSet {
            if newValue {
                switch loginMode {
                case .signUp: self.signUpConfirmed = newValue
                case .signIn: self.signInConfirmed = newValue
                }
            }
        }
    }
    // Update user data
    @Published var updateUserDataPublisher = PassthroughSubject<Void, Error>()
    @Published var signUp = false
    @Published var userWasUpdated = false
    @Published var userPersist = false
    @Published var userCreateCompleted = false
    var presentLoginView =  CurrentValueSubject<LoginViewType, Error>(.signIn)
    var signUpClickPublisher = PassthroughSubject<Void, Error>()
    var createNewUser = PassthroughSubject<UserParam, Error>()
    var saveData = PassthroughSubject<Void, Error>()
    var saveBGLevelsData = PassthroughSubject<Void, Error>()
    var appearBGLevel = PassthroughSubject<Void, Error>()
    override init() {
        super.init()
        handleGettinguser()
        createUser()
        fillUserCredentials()
        handleSignUp()
        handleOnboardingScreen()
        handleLoginScreen()
        updateUserData()
        updatePassword()
        updateGlucoseType()
        updateBGLevelsData()
    }
}
// Init
extension UserViewModel {
    func fillUserCredentials() {
        $signUpConfirmed
            .dropFirst()
            .filter({ $0 })
            .sink { _ in
            }.store(in: &cancellableSet)
    }
    func createUser() {
        createNewUser
            .map { [unowned self]  value -> User in
                let user = User()
                user.id = value.id
                user.name = value.name
                user.email = value.email
                user.password = self.password
                user.birthDate = self.birthDate
                user.gender = self.genderSelectedItem?.type ?? ""
                user.diabetsType = self.diabetSelectedItem?.type ?? ""
                user.glucoseUnit = self.glucoseUnit
                user.glucoseTargetLowerBound = Int(self.glucoseRangeValue.lowerBound)
                user.glucoseTargetUpperBound = Int(self.glucoseRangeValue.upperBound)
                user.hypo = Int(self.hypoValue)
                user.hyper = Int(self.hyperValue)
                user.isVibrate = self.isVibrate
                user.isNotDisturb = self.isNotDisturb
                return user
            }
            .flatMap(save)
            .replaceError(with: false)
            .assign(to: \.userCreateCompleted, on: self)
            .store(in: &cancellableSet)
    }
    func handleSignUp() {
        signUpClickPublisher
            .replaceError(with: ())
            .flatMap({ [unowned self] in self.isComfirmedPublisher })
            .flatMap({ [unowned self] value -> AnyPublisher<Bool, Never> in
                self.showErrorAlert = !value
                return Just(value)
                    .eraseToAnyPublisher()
            })
            .filter({ $0 })
            .flatMap({ [unowned self] _ in self.login() })
            .replaceError(with: false)
            .assign(to: \.isloginModeSignUp, on: self)
            .store(in: &cancellableSet)
    }
    func handleOnboardingScreen() {
        presentOnboardingView
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] type in
                withAnimation {
                    self.selectedOnboardingItem = type
                }
            }
            .store(in: &cancellableSet)
    }
    func handleLoginScreen() {
        presentLoginView
            .receive(on: DispatchQueue.main)
            .sink {  _ in
            } receiveValue: { [unowned self] type in
                withAnimation {
                    self.selectedLoginItem = type
                }
            }
            .store(in: &cancellableSet)
    }
    func updateUserData() {
        updateUserDataPublisher
            .compactMap({ [unowned self] in self.user })
            .flatMap { [unowned self] user in
                updateEntry {
                    user.birthDate = self.birthDate
                    user.gender = self.genderSelectedItem?.type ?? ""
                    user.glucoseUnit = self.glucoseUnit
                    user.password = self.newPassword
                    return user
                }
            }
            .sink { _ in
            } receiveValue: {[unowned self] success in
                withAnimation {
                    self.isDOBPresented = !success
                    self.isGenderPresented = !success
                }
            }
            .store(in: &cancellableSet)
    }
    func updatePassword() {
        isPasswordMatch
            .compactMap({ [unowned self] in self.user })
            .flatMap { [unowned self] user -> AnyPublisher<Bool, Error> in
                if user.password == self.oldPassword {
                    return updateEntry {
                        user.password = self.newPassword
                        return user
                    }
                } else {
                    return Just(false)
                        .mapError({ _ in RealmError.unknow })
                        .eraseToAnyPublisher()
                }
            }
            .map({ success in
                if success {
                    return .match
                } else {
                    return .notMatch
                }
            })
            .replaceError(with: .idle)
            .assign(to: \.passwordMode, on: self)
            .store(in: &cancellableSet)
    }
    func updateGlucoseType() {
        saveData
            .map({ [unowned self] in
                (self.glucoseTypeSelectedItem?.type ?? "", self.user)
            })
            .replaceError(with: ("", nil))
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [unowned self] type, user in
                guard let user = user else { return }
                _ = self.updateEntry {
                    if !self.name.isEmpty {
                        user.name =  self.name
                    }
                    if !self.email.isEmpty {
                        user.email = self.email
                    }
                    if !type.isEmpty {
                        user.glucoseUnit = type
                    }
                    return user
                }
            })
            .store(in: &cancellableSet)
    }
    func updateBGLevelsData() {
        saveBGLevelsData
            .map({[unowned self] _ in  self.setProfile() })
            .compactMap({ [unowned self] _ in self.user })
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [unowned self] user in
                _ = self.updateEntry {
                    user.glucoseTargetLowerBound = Int(self.glucoseRangeValue.lowerBound)
                    user.glucoseTargetUpperBound = Int(self.glucoseRangeValue.upperBound)
                    user.hypo = Int(self.hypoValue)
                    user.hyper = Int(self.hyperValue)
                    user.isVibrate = self.isVibrate
                    user.isNotDisturb = self.isNotDisturb
                    return user
                }
            })
            .store(in: &cancellableSet)
        appearBGLevel
            .compactMap({ [unowned self] _ in self.user })
            .sink { _ in
            } receiveValue: { [unowned self] user in
                self.glucoseRangeValue = user.glucoseTargetLowerBound...user.glucoseTargetUpperBound
                self.hypoValue = user.hypo
                self.hyperValue = user.hyper
                self.isVibrate = user.isVibrate
                self.isNotDisturb = user.isNotDisturb
            }
            .store(in: &cancellableSet)

    }
}
// Handle validate publishers
extension UserViewModel {
    private var isComfirmedPublisher: AnyPublisher<Bool, Never> {
        let isEmailValid = Just(email.isValidEmail())
        let isPasswordEmptyPublisher = Just(password.count > 5)
        return Publishers.CombineLatest(isEmailValid, isPasswordEmptyPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
}

// Handle user data converting
extension UserViewModel {
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    var birthDateParam: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: isUserInvalidated ? user?.birthDate ?? birthDate : Date())
    }
    var birthDateString: String {
        dateFormatter.string(from: isUserInvalidated ?  user?.birthDate ?? birthDate : Date())
    }
    var glucoseUnit: String {
        if isUserInvalidated {
           return glucoseTypeSelectedItem?.type ?? user?.glucoseUnit ?? L10n.mgDL
        }
        return L10n.mgDL
    }
}
// Handle onboarding
extension UserViewModel {
    var completionValue: CGFloat {
        switch selectedOnboardingItem {
        case .signUp: return 0.0
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
        case .signUp: return .signUp
        case .emailSignUp: return .signUp
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
