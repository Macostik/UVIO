//
//  PasswordToastView.swift
//  UVIO
//
//  Created by Macostik on 11.07.2022.
//

import SwiftUI

enum PasswordMode {
    case idle, match, notMatch
}

struct PasswordToastView: ViewModifier {
    let delay: TimeInterval = 3.0
    @Binding var type: PasswordMode
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
          content
          toastView
        }
      }
    private var toastView: some View {
        Group {
            if type == .notMatch {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(L10n.dot)
                        Text(L10n.incorrectPassword)
                    }
                }
            } else if type == .match {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image.passwordSuccessIcon
                        Text(L10n.passwordSuccess)
                    }
                }
            }
        }
        .foregroundColor(type == .match ? Color.greenSuccessColor : Color.white)
        .font(.poppins(.medium, size: 14))
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(type == .match ?
                    Color.successBackgroundColor :
                        type == .notMatch ?
                    Color.primaryAlertColor : Color.clear)
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.greenSuccessColor, lineWidth: type == .match  ? 1 : 0))
        .cornerRadius(16)
        .padding(.horizontal)
        .zIndex(1)
        .onTapGesture {
            type = .idle
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                type = .idle
            }
        }
        .animation(.easeInOut, value: type)
        .transition(.move(edge: .top))
    }
}
