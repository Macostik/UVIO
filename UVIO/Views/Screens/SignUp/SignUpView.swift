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
        ZStack {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 140)
                signUpBanner
                signUpTitle
                containerButtons
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct PrefferableSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: UserViewModel())
    }
}

extension SignUpView {
    var containerButtons: some View {
        VStack(spacing: 12) {
            LogoButton(logo: Image.emailIcon,
                       title: Text(L10n.signUpWithEmail),
                       destination: EmailSignUpView(viewModel: UserViewModel()))
            Button {
                self.viewModel.loginThroughFacebook()
            } label: {
                ZStack {
                    HStack {
                        Image.facebookIcon.padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(Text(L10n.signUpWithFacebook)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            Button {
//                self.facebookProvider.facebookLogin(cUser: currentGiver)
            } label: {
                ZStack {
                    HStack {
                        Image.googleIcon.padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(Text(L10n.signUpWithGoogle)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            Button {
//                self.facebookProvider.facebookLogin(cUser: currentGiver)
            } label: {
                ZStack {
                    HStack {
                        Image.appleIcon.padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(Text(L10n.signUpWihtApple)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
        }
    }
}
