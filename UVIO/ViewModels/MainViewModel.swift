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
    @Published var timeValue = "27 minutes ago"
    @Published var glucoseUnitValue = "mmol/l"
    @Published var user = User()
    @Published var presentMenu = false
    @Published var menuAction: MenuAction = .logBG
    @Published var isClosed = false
    private(set) var menuActionPubliser = PassthroughSubject<MenuAction, Error>()
    private var cancellable = Set<AnyCancellable>()
    init() {
        getUser()
    }
    // Init handler
    func getUser() {
        dependency.provider.storeService.getUser()
            .replaceError(with: nil)
            .compactMap({ $0 })
            .assign(to: \.user, on: self)
            .store(in: &cancellable)
    }
}
