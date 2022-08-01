//
//  EmailSignUpView.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import SwiftUI

struct EmailSignUpView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var showPassword: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                signUpBanner
                    .padding(.bottom, 48)
                    .layoutPriority(0)
                container
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 13)
            }
        }
    }
}

struct EmailSugnUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignUpView(viewModel: UserViewModel())
    }
}

extension EmailSignUpView {
    var container: some View {
        VStack(spacing: 12) {
            TextField(L10n.emailAddress, text: $viewModel.email)
                .padding()
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primaryAlertColor,
                            lineWidth: viewModel.showErrorAlert ? 2 : 0))
                .cornerRadius(12)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .frame(maxHeight: 48)
            passwordInput
            Button {
                viewModel.signUpClickPublisher.send()
            } label: {
                Text(viewModel.loginMode == .signUp ? L10n.signUp: L10n.signIn)
                    .font(.poppins(.medium, size: 14))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.complementaryColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            if viewModel.loginMode == .signIn {
                Button {
                    self.viewModel.presentLoginView.value = .recoveryEmail
                } label: {
                    Text(L10n.forgotPassword)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.complementaryColor)
                        .padding(.top, 25)
                }
            }
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
              TextField(L10n.password, text: $viewModel.password)
            } else {
                SecureField(L10n.password, text: $viewModel.password)
            }
        }
        .padding()
        .font(.poppins(.medium, size: 14))
        .frame(maxWidth: .infinity, maxHeight: 48)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color.primaryAlertColor,
                    lineWidth: viewModel.showErrorAlert ? 2 : 0))
        .cornerRadius(12)
        .padding(.horizontal)
        .overlay(hideOverlay, alignment: .trailing)
    }
}
