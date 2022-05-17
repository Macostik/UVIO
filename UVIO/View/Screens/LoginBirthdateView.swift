//
//  LoginBirthdateView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI

struct LoginBirthdateView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var loginViewModel: LoginViewModel
    @State private var fullName: String = ""
    
    init(viewModel: LoginViewModel) {
        self.loginViewModel  = viewModel
    }
    
    var body: some View {
        ZStack {
            Image("loginViewBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Spacer()
                Text("What is your Name?")
                    .font(.custom("Poppins-Bold", size: 24))
                TextField("My full name", text: $fullName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding()
                
                Spacer()
                nextButton()
                skipButton()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton())
    }
}

struct LoginBirthdateView_Previews: PreviewProvider {
    static var previews: some View {
        LoginBirthdateView(viewModel: LoginViewModel())
    }
}
