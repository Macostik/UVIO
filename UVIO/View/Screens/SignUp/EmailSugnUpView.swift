//
//  EmailSugnUpView.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import SwiftUI

struct EmailSugnUpView: View {
    @ObservedObject private var viewModel: EmailSignUpViewModel
    init(viewModel: EmailSignUpViewModel) {
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
                container
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct EmailSugnUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSugnUpView(viewModel: EmailSignUpViewModel())
    }
}

extension EmailSugnUpView {
    var container: some View {
        VStack(spacing: 12) {
            TextField(L10n.emailAddress, text: $viewModel.email)
                .padding(.leading)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
            TextField(L10n.password, text: $viewModel.password)
                .padding(.leading)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .overlay(hideOverlay, alignment: .trailing)
            NavigationLink(destination: EmptyView()) {
                Text(L10n.signUp)
                    .font(.poppins(.medium, size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
        }
    }
    var hideOverlay: some View {
        VStack {
            Image.hideIcon
        }.padding(.trailing, 32)
    }
}
