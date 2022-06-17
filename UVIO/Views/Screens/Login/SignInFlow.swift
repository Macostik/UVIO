//
//  SignInFlow.swift
//  UVIO
//
//  Created by Macostik on 13.06.2022.
//

import SwiftUI

struct SignInFlow: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundColor
            containerViews
            NavigationLink(isActive: $viewModel.signInConfirmed,
                           destination: {
                ConnectCGMView(userViewModel: viewModel, viewModel: ConnectCGMViewModel())
            }, label: {
                EmptyView()
            })
        }
        .navigationBarHidden(true)
        .toast(isShowing: $viewModel.showErrorAlert)
    }
}

struct SignInFlow_Previews: PreviewProvider {
    static var previews: some View {
        SignInFlow(viewModel: UserViewModel())
    }
}

extension SignInFlow {
    var backgroundColor: some View {
        Image.loginViewBackground
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
    var containerViews: some View {
        VStack {
            NativigationBackBarViewAction(action: {
                withAnimation {
                    viewModel.selectedLoginItem = viewModel.previousLoginType
                }
            }, content: {
                Group {
                    if viewModel.selectedLoginItem == .signIn ||
                        viewModel.selectedLoginItem == .emailSignUp {
                        EmptyView()
                    } else if viewModel.selectedLoginItem == .recoveryEmail ||
                                viewModel.selectedLoginItem == .checkInBox {
                        Text(L10n.forgotPassword)
                    } else {
                        Text(L10n.newPassword)
                    }
                }
                .font(.poppins(.medium, size: 18))
                .foregroundColor(Color.black)
            })
            TabView(selection: $viewModel.selectedLoginItem) {
                SignInView(viewModel: viewModel)
                    .tag(LoginViewType.signIn)
                EmailSignUpView(viewModel: viewModel)
                    .tag(LoginViewType.emailSignUp)
                RecoveryEmailView(viewModel: viewModel)
                    .tag(LoginViewType.recoveryEmail)
                CheckInboxView(viewModel: viewModel)
                    .tag(LoginViewType.checkInBox)
                NewPasswordView(viewModel: viewModel)
                    .tag(LoginViewType.newPassword)
                NewPasswordSuccessView(viewModel: viewModel)
                    .tag(LoginViewType.newPasswordSuccess)
            }.tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}