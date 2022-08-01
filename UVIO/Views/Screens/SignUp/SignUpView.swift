//
//  SignUpView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI
import Combine

struct SignUpView: View {
    @ObservedObject private var viewModel: UserViewModel
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                signUpBanner
                VStack {
                    signUpTitle
                    containerButtons
                }
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 13)
            }
        }
        .onAppear(perform: {
            viewModel.loginMode = .signUp
        })
    }
}

struct PrefferableSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: UserViewModel())
    }
}

extension SignUpView {
    var signUpTitle: some View {
        Text(L10n.signUpMethod)
            .font(.poppins(.medium, size: 18))
            .padding(.top, 45)
            .padding(.bottom, 25)
    }
    var containerButtons: some View {
        VStack(spacing: 12) {
            Button {
                self.viewModel.presentOnboardingView.value = .emailSignUp
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
