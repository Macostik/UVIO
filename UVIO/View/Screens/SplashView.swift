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
                Image("splashBackgroundImage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 16) {
                    Spacer()
                    splashIconView
                    Text("Cone")
                        .bold()
                        .font(.custom("Poppins-Bold", size: 24))
                    Text("Take back the Control over your Diabetes")
                        .font(.custom("Poppins-Regular", size: 21))
                        .multilineTextAlignment(.center)
                        .padding()
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
            Image("uvioIcon")
        }
        .frame(width: 128, height: 128)
    }
    
    var createAccountButton: some View {
        Button(action: {
            print("click create account button")
        }) {
            Text("CREATE ACCOUNT")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color.white)
                .frame(width: UIScreen.main.bounds.width - 24, height: 48)
                .background(Color.black)
                .cornerRadius(12)
        }
    }
    
    var signInButton: some View {
        NavigationLink(destination:
                        LoginNameView(viewModel: LoginViewModel())) {
            Text("SIGN IN")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color.black)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashViewModel())
    }
}
