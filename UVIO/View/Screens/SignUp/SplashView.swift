//
//  SplashView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView {
            ZStack {
                Image.splashBackgroundImage
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 16) {
                    Spacer()
                    splashIconView
                    contentView
                    Spacer()
                    createAccountButton
                    signInButton
                }
            }
        }
    }
    var splashIconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .foregroundColor(Color.white)
            Image.uvioIcon
        }
        .frame(width: 128, height: 128)
    }
    var contentView: some View {
        VStack {
            Text(L10n.cone)
                .bold()
                .foregroundColor(.black)
                .font(.poppins(.bold, size: 24))
            Text(L10n.takeBackControl)
                .font(.poppins(.regular, size: 21))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding()
        }
    }
    var createAccountButton: some View {
        Button {
            print("click create account button")
        } label: {
            Text(L10n.createAccount)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.black)
                .cornerRadius(12)
                .padding()
        }
    }
    var signInButton: some View {
        NavigationLink(destination:
                        NameOnboardingView(viewModel: NameOnboardingViewModel())) {
            Text(L10n.signIn)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashViewModel())
    }
}
