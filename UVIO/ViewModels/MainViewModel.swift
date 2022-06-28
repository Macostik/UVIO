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

class MainViewModel: ObservableObject {
    @Environment(\.dependency) var dependency
    @Published var user = User()
    @Published var listEntries = [ListItem]()
    @Published var isFullHistory = false
    @Published var isShowInfoAlert = true
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
    @Published var isFoodPresented = false
    @Published var foodWhenValue = Date()
    @Published var foodTimeValue = Date()
    @Published var foodCarbs: CarbsPickerData = .c15
    // Handle insulin data
    @Published var insulineNote = ""
    @Published var insulinCounter: Int = 0
    @Published var isInsulinPresented = false
    @Published var subtitle: String = L10n.units
    @Published var insulinMainColor: Color = Color.rapidOrangeColor
    @Published var insulinWhenValue = Date()
    @Published var insulinTimeValue = Date()
    @Published var insulinAction: InsulinAction = .rapid
    // Handle reminder data
    @Published var reminderNote = ""
    @Published var reminderCounter: Int = 0
    @Published var isReminderPresented = false
    @Published var reminderColor: Color = Color.white
    // Handel segmentControl
    let segementItems = InsulinAction.allCases
    @Published var selectedSegementItem = InsulinAction.rapid
    // Handle Info Alert
    @Published var selectedInfoAlertItem: InfoAlertType = .inputValue
    @Published var highAlertCounterValue: Int = 0
    @Published var reminderAlertCounterValue: Int = 0
    @Published var presentAlertItem: InfoAlertType = .inputValue
    @Published var foodNameAlert = ""
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
        isReminderPresented
    }
    init() {
        getUser()
        handleMenuAction()
        handleInsulinSegmentTap()
        handleSubmition()
        handleGettingEntries()
        handleInfoAlertShifting()
    }
    // Init handler
    private func getUser() {
        dependency.provider.storeService.getEntry()
            .replaceError(with: nil)
            .compactMap({ $0 })
            .assign(to: \.user, on: self)
            .store(in: &cancellable)
    }
    private func handleMenuAction() {
        menuActionPubliser
            .sink { _ in
            } receiveValue: { action in
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
            .map({ item -> Color in
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
            .assign(to: \.listEntries, on: self)
            .store(in: &cancellable)
    }
    private func handleInfoAlertShifting() {
        $presentAlertItem
            .sink { type in
                withAnimation {
                    self.selectedInfoAlertItem = type
                }
            }
            .store(in: &cancellable)
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
    func save(entry: Object) -> AnyPublisher<Bool, Error> {
        dependency.provider.storeService.saveEntry(entry: entry)
    }
    func updateEntry<T: Object>(_ entry: @escaping () -> T) -> AnyPublisher<Bool, Error> {
        dependency.provider.storeService.updateEntry(entry)
    }
    func getListEntries() -> AnyPublisher<[ListItem], Error> {
        dependency.provider.storeService.getListEntries()
    }
}

// Handle submit publishers
extension MainViewModel {
    var logBGPublisher: AnyPublisher<Bool, Error> {
        subminLogBGPublisher
            .flatMap({
                return self.updateEntry {
                    let entry = LogBGEntry()
                    entry.logValue = "\(self.logBGInput)"
                    entry.note = self.insulineNote
                    entry.date = self.insulinWhenValue
                    entry.time = self.insulinTimeValue
                    return entry
                }
            }).eraseToAnyPublisher()
    }
    var insulinPublisher: AnyPublisher<Bool, Error> {
        subminInsulinPublisher
            .flatMap({
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
            .flatMap({
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
            .flatMap({
                return self.updateEntry {
                    let entry = ReminderEntry()
                    entry.reminderValue = "\(self.reminderCounter)"
                    entry.note = self.reminderNote
                    return entry
                }
            }).eraseToAnyPublisher()
    }
    func handleSubmition() {
        Publishers.Merge4(logBGPublisher, reminderPublisher, insulinPublisher, foodPublisher)
            .replaceError(with: false)
            .assign(to: \.entryWasUpdated, on: self)
            .store(in: &cancellable)
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
