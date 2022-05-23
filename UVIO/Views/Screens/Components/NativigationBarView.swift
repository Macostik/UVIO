//
//  NativigationBarView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI
import Combine

struct NativigationBarView<Content: View>: View {
    let content: Content?
    init(@ViewBuilder content: () -> Content?) {
        self.content = content()
    }
    var body: some View {
        ZStack {
            HStack {
                BackButton()
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(content)
    }
}
