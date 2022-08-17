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

// swiftlint:disable all

class BaseViewModel: ObservableObject {
    @Published var user: User?
    @Published var name: String = ""
    @Published var email: String = ""
    // Change password
    @Published var isChangePassword = false
    @Published var isPasswordMatch = PassthroughSubject<Void, Error>()
    @Published var passwordMode = PasswordMode.idle
    @Published var password: String = ""
    @Published var recoveryEmail: String = ""
    @Published var newPassword: String = ""
    @Published var oldPassword: String = ""
    // User birthDate
    @Published var birthDate: Date = Date()
    @Published var signInConfirmed = false
    @Published var signUpConfirmed = false
    @Published var isDOBPresented = false
    @Published var showErrorAlert: Bool = false
    // User gender
    @Published var isGenderPresented = false
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
    // Onboarding selection
    @Published var selectedOnboardingItem: OnboardingViewType = .signUp
    // Login  selection
    @Published var selectedLoginItem: LoginViewType = .signIn
    @Published var hasUserlogOut = false {
        willSet {
            self.signInConfirmed = !newValue
            self.signUpConfirmed = !newValue
        }
    }
    @Published var logBGNote = ""
    @Published var foodNote = ""
    @Published var insulineNote = ""
    @Published var reminderNote = ""
    // User glucose
    @Published var glucoseRangeValue: ClosedRange<Int> = 100...160
    @Published var hyperValue: Int = 200
    @Published var hypoValue: Int = 70
    @Published var isVibrate: Bool = false
    @Published var isNotDisturb: Bool = false
    @Published var isMainMenuPresented = false
    @Published var isLogBGPresented = false
    @Published var isReminderPresented = false
    @Published var isInsulinPresented = false
    @Published var isShownWarningAlert = false
    @Published var isNodeAdded = false
    @Published var isShowInfoAlert = false
    @Published var isFoodPresented = false {
        willSet {
//            if !newValue {
//                isFoodCalendarOpen = false
//                isTimePickerOpen = false
//                isCarbsAdded = false
//                isNodeAdded = false
//            }
        }
    }
    // Handle menu
    @Published var menuAction: MenuAction = .logBG
    @Published var isCalendarOpen = false
    // Handle logBG data
    @Published var logBGInput = ""
    @Published var logBGWhenValue = Date()
    @Published var logBGTimeValue = Date()
    // Handle food data
    @Published var foodName = ""
    @Published var isFoodCalendarOpen = false
    @Published var isTimePickerOpen = false
    @Published var isCarbsAdded = false

    @Published var foodWhenValue = Date()
    @Published var foodTimeValue = Date()
    @Published var foodCarbs: CarbsPickerData = .c15
    // Handle insulin data
    @Published var insulinCounter: Int = 0
    @Published var insulinsubtitle: String = L10n.units
    @Published var insulinMainColor: Color = Color.rapidOrangeColor
    @Published var insulinWhenValue = Date()
    @Published var insulinTimeValue = Date()
    @Published var insulinAction: InsulinAction = .rapid
    // Handle reminder data
    @Published var reminderCounter: Int = 0
    @Published var reminderColor: Color = Color.white
    @Published var reminderSubtitle: String = L10n.minutes
    @Published var glucoseTypeSelectedItem: GlucoseType? {
        willSet {
            guard let item = newValue else { return }
            glucoseTypeList.forEach({ $0.isSelected = false })
            glucoseTypeList.first(where: { $0.id == item.id })?.isSelected = true
        }
    }
    @Published var entryWasUpdated = false {
        willSet {
            if newValue {
                handleGettingEntries()
            }
        }
    }
    func handleGettingEntries() {}
    var subminLogBGPublisher = PassthroughSubject<Void, Error>()
    var subminInsulinPublisher = PassthroughSubject<Void, Error>()
    var subminFoodPublisher = PassthroughSubject<Void, Error>()
    var subminReminderPublisher = PassthroughSubject<Void, Error>()
    lazy var glucoseTypeList = [
        GlucoseType(id: 1, type: L10n.mgDL,
                    isSelected: isUserInvalidated ? user?.glucoseUnit == L10n.mgDL : false),
        GlucoseType(id: 2, type: L10n.mmolL,
                    isSelected: isUserInvalidated ?  user?.glucoseUnit == L10n.mmolL : false)
    ]
    var isMenuPresented: Bool {
        isMainMenuPresented ||
        isLogBGPresented ||
        isFoodPresented ||
        isInsulinPresented ||
        isReminderPresented ||
        isShownWarningAlert
    }
    var isSettingsMenuPresented: Bool {
        isDOBPresented ||
        isGenderPresented ||
        isChangePassword
    }
    var presentOnboardingView =  CurrentValueSubject<OnboardingViewType, Error>(.signUp)
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
    var userEmail: String {
        if isUserInvalidated, let user = user {
           return user.email
        }
        return ""
    }
    var userGlucoseUnit: String {
        if isUserInvalidated, let user = user {
           return user.glucoseUnit
        }
        return ""
    }
    var userGender: String {
        if isUserInvalidated, let user = user {
           return user.gender
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
            .replaceError(with: DexcomToken(oauthToken: "",
                                            oauthRefreshToken: ""))
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
            }, receiveValue: { [unowned self] response in
                guard let response = response.value,
                        response.success else {
                    Logger.error("Something went wrong: \(String(describing: response.error))")
                    return
                }
                let user = response.data.user
                self.authToken = response.data.token
                self.userID = String(user.id)
                self.createNewUser.send(user)
                self.sendDexcomTokens()
            })
            .store(in: &cancellableSet)
    }
    func login() -> AnyPublisher<Bool, Error> {
        if loginMode == .signIn {
            return dependency.provider.apiService
                .login(email: email, password: password)
                .flatMap({ [unowned self] response -> AnyPublisher<Bool, Error> in
                    guard let response = response.value
                    else {
                        Logger.error("Something went wrong: \(String(describing: response.error))")
                        return Just(false)
                            .setFailureType(to: Error.self)
                            .eraseToAnyPublisher()
                    }
                    let user = response.data.user
                    self.authToken = response.data.token
                    self.userID = String(user.id)
                    self.createNewUser.send(user)
                    return Just(response.success)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                })
                .eraseToAnyPublisher()
        }
        self.presentOnboardingView.value = .name
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
            }, receiveValue: {[unowned self] response in
                guard let response = response.value,
                        response.success else {
                    Logger.error("Something went wrong: \(String(describing: response.error))")
                    return
                }
                let user = response.data.user
                self.authToken = response.data.token
                self.userID = String(user.id)
                self.createNewUser.send(user)
            })
            .store(in: &cancellableSet)
    }
    func setProfile() {
        let userID = String(user?.id ?? 0)
        dependency.provider.apiService
            .profile(userID: userID,
                     diabetesType: self.diabetSelectedItem?.type ?? "",
                     glucoseUnit: self.glucoseUnit,
                     glucoseTargetMin: String(self.glucoseRangeValue.lowerBound),
                     glucoseTargetMax: String(self.glucoseRangeValue.upperBound),
                     glucoseHyper: String(self.hyperValue),
                     glucoseHypo: String(self.hypoValue),
                     glucoseSensor: "",
                     country: "",
                     alertVibrate: isVibrate ? "1" : "0",
                     dontDisturb: isNotDisturb ? "1" : "0")
            .sink(receiveCompletion: { _ in
            }, receiveValue: { response in
                guard let response = response.value,
                      response.success else {
                    Logger.error("Something went wrong: \(String(describing: response.error))")
                    return
                }
                Logger.debug("Set profile value successfully")
            })
            .store(in: &cancellableSet)
    }
    func sendDexcomTokens() {
        dependency.provider.apiService
            .devices(userID: userID,
                     apiToken: dexcomToken.oauthToken,
                     refreshApiToken: dexcomToken.oauthRefreshToken)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { response in
                guard let response = response.value,
                      response.success else {
                    Logger.error("Something went wrong: \(String(describing: response.error))")
                    return
                }
                Logger.debug("Dexcom token was sent successfully")
            })
            .store(in: &cancellableSet)
    }
}
// Handle login via social frameworks
extension UserViewModel {
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

// Handle submit publishers
extension BaseViewModel {
    var logBGPublisher: AnyPublisher<Bool, Error> {
        subminLogBGPublisher
            .flatMap({ [unowned self] _ in
                return self.updateEntry {
                    let entry = LogBGEntry()
                    entry.logValue = "\(self.logBGInput)"
                    entry.logUnitType = self.user?.glucoseUnit ?? ""
                    entry.note = self.logBGNote
                    entry.date = self.logBGWhenValue
                    entry.time = self.logBGTimeValue
                    entry.note = self.logBGNote
                    self.logBGNote = ""
                    return entry
                }
            }).eraseToAnyPublisher()
    }
    var insulinPublisher: AnyPublisher<Bool, Error> {
        subminInsulinPublisher
            .flatMap({ [unowned self] _ in
                return self.updateEntry {
                    let entry = InsulinEntry()
                    entry.insulinValue = "\(self.insulinCounter)"
                    entry.note = self.insulineNote
                    entry.date = self.insulinWhenValue
                    entry.time = self.insulinTimeValue
                    entry.action = self.insulinAction.rawValue
                    entry.note = self.insulineNote
                    self.insulineNote = ""
                    return entry
                }
            }).eraseToAnyPublisher()
    }
    var foodPublisher: AnyPublisher<Bool, Error> {
        subminFoodPublisher
            .flatMap({ [unowned self] _ in
                return self.updateEntry {
                    let entry = FoodEntry()
                    entry.carbsValue = self.foodCarbs.description
                    entry.note = self.foodNote
                    entry.foodName = self.foodName
                    entry.date = self.foodWhenValue
                    entry.time = self.foodTimeValue
                    entry.note = self.foodNote
                    self.foodNote = ""
                    return entry
                }
            }).eraseToAnyPublisher()
    }
    var reminderPublisher: AnyPublisher<Bool, Error> {
        subminReminderPublisher
            .flatMap({ [unowned self] _ in
                return self.updateEntry {
                    let entry = ReminderEntry()
                    entry.reminderValue = self.minutesToHoursAndMinutes(self.reminderCounter)
                    entry.note = self.reminderNote
                    self.reminderNote = ""
                    return entry
                }
                .map({[unowned self] value in
                    self.startTimer()
                    return value
                })
            }).eraseToAnyPublisher()
    }
    func minutesToHoursAndMinutes(_ minutes: Int) -> String {
        let hour = "\(minutes / 60) : "
        let minutesValue = (minutes % 60)
        let minutesString = minutesValue < 10 ? "0\(minutesValue)" : "\(minutesValue)"
        return hour + minutesString
    }
    func handleSubmition() {
        Publishers.Merge4(logBGPublisher, reminderPublisher, insulinPublisher, foodPublisher)
            .replaceError(with: false)
            .assign(to: \.entryWasUpdated, on: self)
            .store(in: &cancellableSet)
    }
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: CGFloat(self.self.reminderCounter * 60),
                             repeats: false,
                             block: { [unowned self] _ in
            withAnimation {
                self.isShowInfoAlert = true
            }
        })
    }
}
