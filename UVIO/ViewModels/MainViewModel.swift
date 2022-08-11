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
    // Common data
    @Published var glucoseValue = "5.4"
    @Published var glucoseCorrectionValue = "+18"
    @Published var timeValue = "27 minutes ago"
    @Published var glucoseUnitValue = "mmol/l"
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
    private var cancellable = Set<AnyCancellable>()
    @Published var keyboardPadding: CGFloat = 0
    var isShownBottomPlaceholder: Bool {
        listEntries.isEmpty ||
        isShowInfoAlert
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
    override func handleGettingEntries() {
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
