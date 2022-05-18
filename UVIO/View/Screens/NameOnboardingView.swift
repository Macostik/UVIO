//
//  NameOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI
import Combine

struct NameOnboardingView: View {
    
    @ObservedObject var loginViewModel: NameOnboardingViewModel
    @State private var fullName: String = ""
    
    init(viewModel: NameOnboardingViewModel) {
        self.loginViewModel  = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(Asset.Assets.loginViewBackground.name)
                .resizable()
                .edgesIgnoringSafeArea(.all)
           
            VStack(spacing: 16) {
                Spacer()
                contentView
                Spacer()
                nextButton(destination: BirthDateOnboardingView(viewModel: BirthDateOnboardingViewModel()))
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
            Text(L10n.whatName)
                .font(.custom("Poppins-Bold", size: 24))
            TextField(L10n.fullName, text: $fullName)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding()
        }
    }
    
   
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NameOnboardingView(viewModel: NameOnboardingViewModel())
    }
}

