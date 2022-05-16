//
//  LoginNameView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI
import Combine

struct LoginNameView: View {
    
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
                    .background(.white)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginNameView(viewModel: LoginViewModel())
    }
}

struct backButton: View  {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("backButtonIcon")
        }
    }
}

struct nextButton: View {
    
    var body: some View {
        NavigationLink(destination:
                        LoginNameView(viewModel: LoginViewModel())) {
            HStack {
                Spacer()
                Text("Next")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(Color.white)
                    .offset(x: 20)
                Spacer()
                Image("nextIcon")
                    .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 24, height: 48)
            .background(Color.black)
            .cornerRadius(12)
        }
    }
}

struct skipButton: View {
    
    var body: some View {
        Button(action: {
            print("skip button click")
        }, label: {
            Text("Skip")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color.black)
        })
    }
}
