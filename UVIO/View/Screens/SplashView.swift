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
        ZStack {
            Image("splashBackgroundImage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Spacer()
                splashIconView
                Text("Cone")
                    .bold()
                    .font(.title2)
                Text("Take back the Control over your Diabetes")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                createAccountButton
                signInButton
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
                .foregroundColor(Color.white)
                .frame(width: UIScreen.main.bounds.width - 24, height: 48)
                .background(Color.black)
                .cornerRadius(12)
        }
    }
    
    var signInButton: some View {
        Button("SIGN IN") {
            print("click signIn button")
        }
        .foregroundColor(Color.black)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: SplashViewModel())
    }
}
