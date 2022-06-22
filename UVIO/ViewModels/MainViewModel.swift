//
//  MainViewModel.swift
//  UVIO
//
//  Created by Macostik on 08.06.2022.
//

import Foundation
import Combine
import SwiftUI

class MainViewModel: ObservableObject {
    @Environment(\.dependency) var dependency
    @Published var user = User()
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
    // Handle remainder data
    @Published var remainderNote = ""
    @Published var remainderCounter: Int = 0
    @Published var isRemainderPresented = false
    @Published var remainderColor: Color = Color.white
    // Handel segmentControl
    let segementItems = [L10n.rapidAction, L10n.logAction]
    @Published var selectedSegementItem = L10n.rapidAction
    private(set) var menuActionPubliser = PassthroughSubject<MenuAction, Error>()
    private var cancellable = Set<AnyCancellable>()
     var isPresented: Bool {
        isMenuPresented ||
         isLogBGPresented ||
         isFoodPresented ||
         isInsulinPresented ||
         isRemainderPresented
    }
    init() {
        getUser()
        handleMenuAction()
        handleInsulinSegmentTap()
    }
    // Init handler
    func getUser() {
        dependency.provider.storeService.getUser()
            .replaceError(with: nil)
            .compactMap({ $0 })
            .assign(to: \.user, on: self)
            .store(in: &cancellable)
    }
    func handleMenuAction() {
        menuActionPubliser
            .sink { _ in
            } receiveValue: { action in
                withAnimation {
                    switch action {
                    case .logBG: self.isLogBGPresented = true
                    case .insulin: self.isInsulinPresented = true
                    case .food: self.isFoodPresented = true
                    case .reminder: self.isRemainderPresented = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    func handleInsulinSegmentTap() {
        $selectedSegementItem
            .map({ item -> Color in
                if item == L10n.rapidAction {
                    return Color.rapidOrangeColor
                } else {
                    return Color.primaryCayanColor
                }
            })
            .assign(to: \.insulinMainColor, on: self)
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
