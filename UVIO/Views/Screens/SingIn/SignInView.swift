//
//  SignInView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI
import Resolver

struct SignInView: View {
    @ObservedObject  var viewModel: UserViewModel
    @Injected private var dependency: Dependency
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 140)
                signInBanner
                signInTitle
                containerButtons
                forgotPassword
                    .padding(.top)
                Spacer()
                singUpLink
            }
            NativigationBackBarView {}
        }
        .navigationBarHidden(true)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: UserViewModel())
    }
}

extension SignInView {
    var containerButtons: some View {
        VStack(spacing: 12) {
            LogoButton(logo: Image.emailIcon,
                       title: Text(L10n.signInWithEmail),
                       destination: EmailSingInView(viewModel: viewModel))
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
                .overlay(Text(L10n.signUpWithFacebook)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
            NavigationLink(isActive: $viewModel.userWasUpdated) {
                ConnectCGMView(userViewModel: viewModel,
                               viewModel: ConnectCGMViewModel())
            } label: {
                EmptyView()
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
                .overlay(Text(L10n.signInWithGoogle)
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
                .overlay(Text(L10n.signInWihtApple)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.black))
            }
        }
    }
    var forgotPassword: some View {
        NavigationLink {
            RecoveryEmailView(viewModel: viewModel)
        } label: {
            Text(L10n.forgotPassword)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.complementaryColor)
        }
    }
}
