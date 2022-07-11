//
//  View+Ext.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
extension View {
    func toast(isShowing: Binding<Bool>) -> some View {
        self.modifier(ToastView(isShowing: isShowing))
    }
    func passwordToast(type: Binding<PasswordMode>) -> some View {
        self.modifier(PasswordToastView(type: type))
    }
    func getSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self,
                                value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
