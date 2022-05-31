//
//  NameOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI
import Combine
import Resolver

struct NameOnboardingView: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Spacer()
                contentView
                Spacer()
                NextButton(destination:
                            BirthDateOnboardingView(viewModel: viewModel))
                SkipButton(destination: SignUpView(viewModel: viewModel))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                ProgressView(completed: 0.2)
            }
        })
    }

    var contentView: some View {
        VStack {
            Text(L10n.whatName)
                .font(.poppins(.bold, size: 24))
            TextField(L10n.fullName, text: $viewModel.name)
                .padding(.leading)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NameOnboardingView(viewModel: UserViewModel())
    }
}
