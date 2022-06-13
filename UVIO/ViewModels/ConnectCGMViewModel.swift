//
//  ConnectCGMViewModel.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import Foundation
import Combine
import SwiftUI

class ConnectCGMViewModel: ObservableObject {
    var timer = PassthroughSubject<Void, Never>()
    private var cancellableSet = Set<AnyCancellable>()
    @Published var isHiddenWelcomeSplashScreen = false
    init() {
        timer
            .timeout(.seconds(1.5), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { _  in
                withAnimation(Animation.linear(duration: 1.0)) {
                    self.isHiddenWelcomeSplashScreen.toggle()
                }
            }, receiveValue: { _ in
            })
            .store(in: &cancellableSet)
    }
}
