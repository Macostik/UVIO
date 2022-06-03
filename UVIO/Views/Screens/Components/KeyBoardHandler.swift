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
    @Published private(set) var height: CGFloat = 0
    private var cancable: AnyCancellable?
    private var cancel = Set<AnyCancellable>()
    private var keyboardWillShow = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap({ _ in return CGFloat(50) })
//        .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }
    private var keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .compactMap { _ in return CGFloat.zero }
    init() {
        cancable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .assign(to: \.height, on: self)
    }
}
