//
//  MainViewModel.swift
//  UVIO
//
//  Created by Macostik on 08.06.2022.
//

import Foundation
import Combine
import SwiftUI
import RealmSwift

protocol MainViewModelProvider {
    var mainViewModel: BaseViewModel { get }
}

class MainViewModel: BaseViewModel {
    @Published var listEntriesOrigin = [ListItem]() {
        willSet {
            listEntries =  newValue
        }
    }
    @Published var listEntries = [ListItem]()
    @Published var isFullHistory = false
    @Published var isShowCalendarHistory = false
    @Published var isShowInfoAlert = false
    // Common data
    @Published var glucoseValue = "5.4"
    @Published var glucoseCorrectionValue = "+18"
    @Published var timeValue = "27 minutes ago"
    @Published var glucoseUnitValue = "mmol/l"
    // Handle menu
    @Published var menuAction: MenuAction = .logBG
    @Published var isMenuPresented = false
    @Published var isCalendarOpen = false
    // Handle logBG data
    @Published var logBGNote = ""
    @Published var logBGInput = ""
    @Published var logBGWhenValue = Date()
    @Published var logBGTimeValue = Date()
    @Published var isLogBGPresented = false
    // Handle food data
    @Published var foodNote = ""
    @Published var foodName = ""
    @Published var isFoodCalendarOpen = false
    @Published var isTimePickerOpen = false
    @Published var isCarbsAdded = false
    @Published var isNodeAdded = false
    @Published var isFoodPresented = false {
        willSet {
            if !newValue {
                isFoodCalendarOpen = false
                isTimePickerOpen = false
                isCarbsAdded = false
                isNodeAdded = false
            }
        }
    }
    @Published var foodWhenValue = Date()
    @Published var foodTimeValue = Date()
    @Published var foodCarbs: CarbsPickerData = .c15
    // Handle insulin data
    @Published var insulineNote = ""
    @Published var insulinCounter: Int = 0
    @Published var isInsulinPresented = false
    @Published var insulinsubtitle: String = L10n.units
    @Published var insulinMainColor: Color = Color.rapidOrangeColor
    @Published var insulinWhenValue = Date()
    @Published var insulinTimeValue = Date()
    @Published var insulinAction: InsulinAction = .rapid
    // Handle reminder data
    @Published var reminderNote = ""
    @Published var reminderCounter: Int = 0
    @Published var isReminderPresented = false
    @Published var reminderColor: Color = Color.white
    @Published var reminderSubtitle: String = L10n.minutes
    // Handel segmentControl
    let segementItems = InsulinAction.allCases
    @Published var selectedSegementItem = InsulinAction.rapid
    // Handle Info Alert
    @Published var selectedInfoAlertItem: InfoAlertType = .inputValue
    @Published var highAlertCounterValue: Int = 0
    @Published var reminderAlertCounterValue: Int = 0
    @Published var presentAlertItem: InfoAlertType = .inputValue
    @Published var foodNameAlert = ""
    @Published var isShownWarningAlert = false
    // Publishers
    private(set) var menuActionPubliser = PassthroughSubject<MenuAction, Error>()
    private(set) var subminLogBGPublisher = PassthroughSubject<Void, Error>()
    private(set) var subminInsulinPublisher = PassthroughSubject<Void, Error>()
    private(set) var subminFoodPublisher = PassthroughSubject<Void, Error>()
    private(set) var subminReminderPublisher = PassthroughSubject<Void, Error>()
    private var cancellable = Set<AnyCancellable>()
    @Published var entryWasUpdated = false {
        willSet {
            if newValue {
                handleGettingEntries()
            }
        }
    }
    var isPresented: Bool {
        isMenuPresented ||
        isLogBGPresented ||
        isFoodPresented ||
        isInsulinPresented ||
        isReminderPresented ||
        isShownWarningAlert
    }
    override init() {
        super.init()
        handleMenuAction()
        handleInsulinSegmentTap()
        handleSubmition()
        handleGettingEntries()
        handleInfoAlertShifting()
    }
    // Init handler
    private func handleMenuAction() {
        menuActionPubliser
            .sink { _ in
            } receiveValue: { [unowned self] action in
                withAnimation {
                    switch action {
                    case .logBG: self.isLogBGPresented = true
                    case .insulin: self.isInsulinPresented = true
                    case .food: self.isFoodPresented = true
                    case .reminder: self.isReminderPresented = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    private func handleInsulinSegmentTap() {
        $selectedSegementItem
            .map({ [unowned self] item -> Color in
                self.insulinAction = item
                if item == .rapid {
                    return Color.rapidOrangeColor
                } else {
                    return Color.primaryCayanColor
                }
            })
            .assign(to: \.insulinMainColor, on: self)
            .store(in: &cancellable)
    }
    private func handleGettingEntries() {
        getListEntries()
            .replaceError(with: [])
            .assign(to: \.listEntriesOrigin, on: self)
            .store(in: &cancellable)
    }
    private func handleInfoAlertShifting() {
        $presentAlertItem
            .sink { [unowned self] type in
                withAnimation {
                    self.selectedInfoAlertItem = type
                }
            }
            .store(in: &cancellable)
    }
    func sortListEntries(by date: String) {
       listEntries = listEntriesOrigin.filter({ $0.keyObject == date })
    }
    func resoreListEntries() {
       listEntries = listEntriesOrigin
    }
}

// Handle store entries
extension MainViewModel {
    func getLogBG() -> AnyPublisher<LogBGEntry?, Error> {
        dependency.provider.storeService.getEntry()
    }
    func getFood() -> AnyPublisher<FoodEntry?, Error> {
        dependency.provider.storeService.getEntry()
    }
    func getInsulin() -> AnyPublisher<InsulinEntry?, Error> {
        dependency.provider.storeService.getEntry()
    }
    func getReminder() -> AnyPublisher<ReminderEntry?, Error> {
        dependency.provider.storeService.getEntry()
    }
    func getListEntries() -> AnyPublisher<[ListItem], Error> {
        dependency.provider.storeService.getListEntries()
    }
}

// Handle submit publishers
extension MainViewModel {
    var logBGPublisher: AnyPublisher<Bool, Error> {
        subminLogBGPublisher
            .flatMap({ [unowned self] _ in
                return self.updateEntry {
                    let entry = LogBGEntry()
                    entry.logValue = "\(self.logBGInput)"
                    entry.logUnitType = self.user?.glucoseUnit ?? ""
                    entry.note = self.insulineNote
                    entry.date = self.insulinWhenValue
                    entry.time = self.insulinTimeValue
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
                    entry.note = self.foodNote
                    entry.date = self.foodWhenValue
                    entry.time = self.foodTimeValue
                    entry.action = self.insulinAction.rawValue
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
                    return entry
                }
            }).eraseToAnyPublisher()
    }
    var reminderPublisher: AnyPublisher<Bool, Error> {
        subminReminderPublisher
            .flatMap({ [unowned self] _ in
                return self.updateEntry {
                    let entry = ReminderEntry()
                    entry.reminderValue = "\(self.reminderCounter)"
                    entry.note = self.reminderNote
                    return entry
                }
                .map({[unowned self] value in
                    self.startTimer()
                    return value
                })
            }).eraseToAnyPublisher()
    }
    func handleSubmition() {
        Publishers.Merge4(logBGPublisher, reminderPublisher, insulinPublisher, foodPublisher)
            .replaceError(with: false)
            .assign(to: \.entryWasUpdated, on: self)
            .store(in: &cancellable)
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

extension MainViewModel {
    var selectedLogBGDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: logBGWhenValue)
    }
    var selectedLogBGTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: logBGTimeValue)
    }
    var selectedFoodDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: foodWhenValue)
    }
    var selectedFoodTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: foodTimeValue)
    }
    var selectedInsulinDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: insulinWhenValue)
    }
    var selectedInsulinTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: insulinTimeValue)
    }
}
