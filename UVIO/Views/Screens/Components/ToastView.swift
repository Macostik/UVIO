//
//  ToastView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI

struct ToastView: ViewModifier {
    let delay: TimeInterval = 3.0
    @Binding var isShowing: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
          content
          toastView
        }
      }
    private var toastView: some View {
        Group {
            if isShowing {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(L10n.dot)
                        Text(L10n.emailIsRequired)
                    }
                    HStack {
                        Text(L10n.dot)
                        Text(L10n.passwordIsRequired)
                    }
                }
            }
        }
        .foregroundColor(Color.white)
        .font(.poppins(.medium, size: 14))
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryAlertColor)
        .cornerRadius(16)
        .padding(.horizontal)
        .zIndex(1)
        .onTapGesture {
            isShowing = false
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                isShowing = false
            }
        }
        .animation(.easeInOut, value: isShowing)
        .transition(.move(edge: .top))
    }
}
