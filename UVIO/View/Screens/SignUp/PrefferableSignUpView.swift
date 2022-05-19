//
//  PrefferableSignUpView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI
import Combine

struct PrefferableSignUpView: View {
    @ObservedObject private var viewModel: PreferrableSignUpViewModel
    init(viewModel: PreferrableSignUpViewModel) {
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
        PrefferableSignUpView(viewModel: PreferrableSignUpViewModel())
    }
}

extension PrefferableSignUpView {
    var containerButtons: some View {
        VStack(spacing: 12) {
            LogoButton(logo: Image.emailIcon,
                       title: Text(L10n.signUpWithEmail),
                       destination: EmailSugnUpView(viewModel: EmailSignUpViewModel()))
            LogoButton(logo: Image.facebookIcon,
                       title: Text(L10n.signUpWithFacebook),
                       destination: EmptyView())
            LogoButton(logo: Image.googleIcon,
                       title: Text(L10n.signUpWithGoogle),
                       destination: EmptyView())
            LogoButton(logo: Image.appleIcon,
                       title: Text(L10n.signUpWihtApple),
                       destination: EmptyView())
        }
    }
}
