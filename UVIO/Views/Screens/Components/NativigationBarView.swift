//
//  NativigationBarView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI
import Combine

struct NativigationBackBarViewAction<Content: View>: View {
    let action: () -> Void
    let content: Content?
    init(action:@escaping () -> Void, @ViewBuilder content: () -> Content?) {
        self.action = action
        self.content = content()
    }
    var body: some View {
        ZStack {
            HStack {
                BackButtonAction(action: action)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(content)
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

struct NativigationBarView<Content: View>: View {
    let content: Content?
    let action: (() -> Void)
    init(action: @escaping (() -> Void), @ViewBuilder content: () -> Content?) {
        self.action = action
        self.content = content()
    }
    var body: some View {
        ZStack {
            HStack {
                Image.uvioIcon
                    .resizable()
                    .frame(width: 28, height: 25)
                    .aspectRatio(contentMode: .fit)
                Spacer()
                Image.menuIcon
                    .onLongPressGesture {
                        action()
                    }
            }
            .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .overlay(content)
    }
}
