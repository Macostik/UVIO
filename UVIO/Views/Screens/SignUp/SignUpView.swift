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
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                signUpBanner
                VStack {
                    signUpTitle
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

struct PrefferableSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: UserViewModel())
    }
}

extension SignUpView {
    var containerButtons: some View {
        VStack(spacing: 12) {
            LogoButton(logo: Image.emailIcon,
                       title: Text(L10n.continueWithEmail),
                       destination: EmailSignUpView(viewModel: viewModel))
            Button {
                self.viewModel.facebookPublisher.send()
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
                self.viewModel.googlePublisher.send()
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
                .overlay(Text(L10n.continueWithApple)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
        }
    }
}
