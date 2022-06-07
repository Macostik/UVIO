//
//  SingInView.swift
//  UVIO
//
//  Created by Macostik on 03.06.2022.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                signUpBanner
                VStack {
                    signInTitle
                    containerButtons
                }
                Spacer()
                privatePolicy
                    .multilineTextAlignment(.center)
            }.padding(.top, 60)
            NavigationLink(destination:
                            OnboardingView(viewModel: viewModel),
                           isActive: $viewModel.signUpConfirmed) {
                EmptyView()
            }
            NativigationBackBarView {}
        }
        .navigationBarHidden(true)
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
            .font(.poppins(.medium, size: 21))
            .padding(.horizontal)
            .padding(.top, 60)
            .multilineTextAlignment(.center)
            .padding(.bottom, 48)
    }
    var containerButtons: some View {
        VStack(spacing: 12) {
            LogoButton(logo: Image.emailIcon,
                       title: Text(L10n.continueWithEmail),
                       destination: EmailSignUpView(viewModel: viewModel))
            Button {
                self.viewModel.facebookLogin()
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
                .overlay(Text(L10n.continueWithFacebook)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            Button {
                self.viewModel.googleLogin()
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
                .overlay(Text(L10n.continueWithGoogle)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            Button {
                self.viewModel.appleLogin()
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
                .overlay(Text(L10n.continueWithApple)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
        }
    }
}
