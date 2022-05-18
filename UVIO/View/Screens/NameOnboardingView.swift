//
//  LoginNameView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI
import Combine

struct LoginNameView: View {
    
    @ObservedObject var loginViewModel: LoginNameViewModel
    @State private var fullName: String = ""
    
    init(viewModel: LoginNameViewModel) {
        self.loginViewModel  = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("loginViewBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
           
            VStack(spacing: 16) {
                Spacer()
                contentView
                Spacer()
                nextButton(destination: LoginBirthdateView(viewModel: LoginBirthDateViewModel()))
                skipButton()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                progressView(completed: 0.2)
            }
        })
    }
    
    var contentView: some View {
        VStack {
            Text("What is your Name?")
                .font(.custom("Poppins-Bold", size: 24))
            TextField("My full name", text: $fullName)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding()
        }
    }
    
   
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginNameView(viewModel: LoginNameViewModel())
    }
}

