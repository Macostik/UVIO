//
//  SplashView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        NavigationView {
            if viewModel.isUserlogOut {
                MainView()
            } else {
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
        .environmentObject(viewModel)
    }
    var splashIconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .foregroundColor(Color.white)
            Image.uvioIcon
                .resizable()
                .frame(width: 51, height: 40)
        }
        .frame(width: 128, height: 128)
    }
    var contentView: some View {
        VStack {
            Text(L10n.cone)
                .bold()
                .foregroundColor(.black)
                .font(.poppins(.bold, size: 24))
                .padding(.top, 0)
                .padding(.bottom, 20)
            Text(L10n.takeBackControl)
                .font(.poppins(.medium, size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.top, 2)
        }
    }
    var createAccountButton: some View {
        NavigationLink(destination: SignUpFlow(viewModel: viewModel)) {
            Text(L10n.createAccount)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.complementaryColor)
                .cornerRadius(12)
                .padding()
        }
    }
    var signInButton: some View {
        NavigationLink(destination: SignInFlow(viewModel: viewModel)) {
            Text(L10n.signIn.uppercased())
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: UserViewModel())
    }
}
