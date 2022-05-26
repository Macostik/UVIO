//
//  RecoveryEmailView.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import SwiftUI

struct RecoveryEmailView: View {
    @ObservedObject private var viewModel: UserViewModel
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                container
                Spacer()
                sendRecoveryEmailLink
            }
            NativigationBarView {
                Text(L10n.forgotPassword)
                    .font(.poppins(.medium, size: 18))
            }
        }
        .navigationBarHidden(true)
    }
    var container: some View {
        VStack(spacing: 24) {
            Text(L10n.enterEmail)
                .font(.poppins(.regular, size: 21))
                .multilineTextAlignment(.center)
            TextField(L10n.emailAddress, text: $viewModel.recoveryEmail)
                .padding(.leading)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
        }
    }
    var sendRecoveryEmailLink: some View {
        NavigationLink {
            CheckInboxView(viewModel: viewModel)
        } label: {
            Text(L10n.sendEmailRecovery)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
        }
    }
}

struct RecoveryEmailView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryEmailView(viewModel: UserViewModel())
    }
}
