//
//  EmailSingInView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI

struct EmailSingInView: View {
    @ObservedObject private var viewModel: UserViewModel
    @State private var showPassword: Bool = false
    @State private var showErrorAlert: Bool = false
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 140)
                signInBanner
                signInTitle
                container
                forgotPassword
                    .padding(.top)
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
            }
            NativigationBarView {
                Text(L10n.forgotPassword)
                    .font(.poppins(.medium, size: 18))
            }
        }
        .navigationBarHidden(true)
        .toast(isShowing: $showErrorAlert)
    }
}

struct EmailSingInView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSingInView(viewModel: UserViewModel())
    }
}

extension EmailSingInView {
    var container: some View {
        VStack(spacing: 12) {
            TextField(L10n.emailAddress, text: $viewModel.email)
                .padding(.leading)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primaryAlertColor, lineWidth: showErrorAlert ? 2 : 0))
                .cornerRadius(16)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
            passwordInput
            NavigationLink(destination: EmptyView(), isActive: $viewModel.signUpConfirmed) {
                EmptyView()
            }
            Button {
                withAnimation {
                    showErrorAlert = true
                }
            } label: {
                Text(L10n.signIn)
                    .font(.poppins(.medium, size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(16)
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
     }.padding(.leading)
            .font(.poppins(.medium, size: 14))
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryAlertColor, lineWidth: showErrorAlert ? 2 : 0))
            .cornerRadius(16)
            .padding(.horizontal)
            .overlay(hideOverlay, alignment: .trailing)
    }
}
