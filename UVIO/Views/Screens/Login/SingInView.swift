//
//  SingInView.swift
//  UVIO
//
//  Created by Macostik on 03.06.2022.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject private var viewModel: UserViewModel
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                signUpBanner
                    .offset(y: -28)
                VStack {
                    signInTitle
                    containerButtons
                }
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 13)
            }
        }
        .onAppear(perform: {
            viewModel.loginMode = .signIn
        })
    }
}

struct PrefferableSignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: UserViewModel())
    }
}

extension SignInView {
    var signInTitle: some View {
        Text(L10n.welcomeBack)
            .font(.poppins(.medium, size: 18))
            .padding(.top, 18)
            .multilineTextAlignment(.center)
            .padding(.bottom, 30)
    }
    var containerButtons: some View {
        VStack(spacing: 12) {
            Button {
                self.viewModel.presentLoginView.value = .emailSignUp
            } label: {
                ZStack {
                    HStack {
                        Image.emailIcon
                            .resizable()
                            .frame(width: 20, height: 16)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(Text(L10n.continueWithEmail)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            Button {
                self.viewModel.facebookLogin()
            } label: {
                ZStack {
                    HStack {
                        Image.facebookIcon
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(Text(L10n.continueWithFacebook)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            Button {
                self.viewModel.googleLogin()
            } label: {
                ZStack {
                    HStack {
                        Image.googleIcon
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(Text(L10n.continueWithGoogle)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
//            Button {
//                self.viewModel.appleLogin()
//            } label: {
//                ZStack {
//                    HStack {
//                        Image.appleIcon.padding()
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
//                .background(Color.white.opacity(0.6))
//                .cornerRadius(12)
//                .padding(.horizontal)
//                .overlay(Text(L10n.continueWithApple)
//                    .font(.poppins(.medium, size: 14))
//                    .foregroundColor(.black))
//            }
        }
    }
}
