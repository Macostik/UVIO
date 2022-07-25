//
//  NewPasswordView.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import SwiftUI

struct NewPasswordView: View {
    @ObservedObject private var viewModel: UserViewModel
    @State private var showPassword: Bool = false
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                container
                Spacer()
                continueLink
            }
        }
    }
    var container: some View {
        VStack(spacing: 24) {
            Text(L10n.enterNewPasswordAndContinue)
                .font(.poppins(.medium, size: 18))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            passwordInput
        }
    }
    var continueLink: some View {
        Button {
            self.viewModel.presentLoginView.value = .newPasswordSuccess
        } label: {
            Text(L10n.continue)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.complementaryColor)
                .foregroundColor(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
    var hideOverlay: some View {
        VStack {
            if showPassword {
                Image.eyeIcon
            } else {
                Image.hideIcon
            }
        }.padding(.trailing, 32)
            .onTapGesture {
                $showPassword.wrappedValue.toggle()
            }
    }
    var passwordInput: some View {
        Group {
            if showPassword {
                TextField(L10n.newPassword, text: $viewModel.newPassword)
            } else {
                SecureField(L10n.newPassword, text: $viewModel.newPassword)
            }
        }.padding(.leading)
            .font(.poppins(.medium, size: 14))
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(hideOverlay, alignment: .trailing)
    }
}

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordView(viewModel: UserViewModel())
    }
}
