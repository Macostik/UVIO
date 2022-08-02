//
//  NativigationBarView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI
import Combine

struct NavigationBackBarViewAction<Content: View>: View {
    let action: () -> Void
    let content: Content?
    let backgroundColor: Color
    init(action:@escaping () -> Void,
         @ViewBuilder content: () -> Content?,
         backgroundColor: Color = .clear,
         isTopInset: Bool = false) {
        self.action = action
        self.content = content()
        self.backgroundColor = backgroundColor
    }
    var body: some View {
        ZStack {
            BackButtonAction(action: action)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
        .background(backgroundColor)
        .overlay(content)
        .offset(x: -1, y: -5)
    }
}

struct NativigationBackBarView<Content: View>: View {
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

struct NavigationBarView<Content: View, Destination: View>: View {
    let content: Content?
    let destination: (() -> Destination)
    let disabled: Bool
    init(destination: @escaping (() -> Destination),
         @ViewBuilder content: () -> Content?,
         disabled: Bool = false) {
        self.destination = destination
        self.content = content()
        self.disabled = disabled
    }
    var body: some View {
        ZStack {
            HStack {
                Image.uvioIcon
                    .resizable()
                    .frame(width: 28, height: 25)
                    .aspectRatio(contentMode: .fit)
                Spacer()
                NavigationLink {
                    destination()
                } label: {
                    Image.settingsIcon
                }
                .disabled(disabled)
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .overlay(content)
    }
}
