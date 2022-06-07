//
//  EmailSignUpView.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import SwiftUI

struct EmailSignUpView: View {
    @ObservedObject private var keyboardHandler = KeyboardHandler()
    @ObservedObject private var viewModel: UserViewModel
    @State private var showPassword: Bool = false
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                signUpBanner
                    .padding(.bottom, 40)
                    .layoutPriority(0)
                title
                container
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 45)
            NavigationLink(destination:
                            OnboardingView(viewModel: viewModel),
                           isActive: $viewModel.signUpConfirmed) {
                EmptyView()
            }
            NativigationBackBarView {}
        }
        .navigationBarHidden(true)
        .toast(isShowing: $viewModel.showErrorAlert)
    }
}

struct EmailSugnUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignUpView(viewModel: UserViewModel())
    }
}

extension EmailSignUpView {
    var title: some View {
        Text(L10n.pleaseEnterYourEmailPassword)
            .font(.poppins(.medium, size: 21))
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .padding(.bottom, 30)
            .minimumScaleFactor(0.68)
    }
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
        }
    }
    var hideOverlay: some View {
        VStack {
            Image.hideIcon
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
