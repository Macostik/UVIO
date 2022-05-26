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
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                container
                Spacer()
                continueLink
            }
            NativigationBackBarView {
                Text(L10n.newPassword)
                    .font(.poppins(.medium, size: 18))
            }
        }
        .navigationBarHidden(true)
    }
    var container: some View {
        VStack(spacing: 24) {
            Text(L10n.enterNewPasswordAndContinue)
                .font(.poppins(.regular, size: 21))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            passwordInput
        }
    }
    var continueLink: some View {
        NavigationLink {
            NewPasswordSuccessView(viewModel: viewModel)
        } label: {
            Text(L10n.continue)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
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
              TextField(L10n.newPassword, text: $viewModel.newPassword)
            } else {
                SecureField(L10n.newPassword, text: $viewModel.newPassword)
            }
     }.padding(.leading)
            .font(.poppins(.medium, size: 14))
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal)
            .overlay(hideOverlay, alignment: .trailing)
    }
}

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordView(viewModel: UserViewModel())
    }
}
