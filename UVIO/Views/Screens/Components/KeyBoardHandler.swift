//
//  KeyBoardHandler.swift
//  UVIO
//
//  Created by Macostik on 31.05.2022.
//

import UIKit
import Combine
import SwiftUI

class KeyboardHandler: ObservableObject {
    @Published var height: CGFloat = 0
    private var cancel = Set<AnyCancellable>()
        init() {
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { _ in return 50}
                .receive(on: DispatchQueue.main)
                .assign(to: \.height, on: self)
                .store(in: &cancel)
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .compactMap { _ in return 0.0 }
                .receive(on: DispatchQueue.main)
                .assign(to: \.height, on: self)
                .store(in: &cancel)
        }
}
