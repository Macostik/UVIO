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
    @Published var glucoseValue = "5.4"
    @Published var glucoseCorrectionValue = "+18"
    @Published var timeValue = "27 minutes ago"
    @Published var glucoseUnitValue = "mmol/l"
    @Published var user = User()
    @Published var menuAction: MenuAction = .logBG
    @Published var isMenuPresented = false
    @Published var isLogBGPresented = false
    @Published var logBGInput = ""
    @Published var logBGWhenValue = ""
    @Published var logBGDateValue = Date()
    private(set) var menuActionPubliser = PassthroughSubject<MenuAction, Error>()
    private var cancellable = Set<AnyCancellable>()
    init() {
        getUser()
        handleMenuAction()
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
                    case .insulin: self.isLogBGPresented = true
                    case .food: self.isLogBGPresented = true
                    case .reminder: self.isLogBGPresented = true
                    }
                }
            }
            .store(in: &cancellable)

    }
}

extension MainViewModel {
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
}
