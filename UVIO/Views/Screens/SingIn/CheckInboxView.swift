//
//  CheckInboxView.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import SwiftUI

struct CheckInboxView: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                container
                Spacer()
                openEmailAppLink
            }
            NativigationBackBarView {
                Text(L10n.forgotPassword)
                    .font(.poppins(.medium, size: 18))
            }
        }
        .navigationBarHidden(true)
    }
    var container: some View {
        VStack(spacing: 24) {
            Image.emailIcon
                .frame(width: 68, height: 68)
                .background(Color.white)
                .cornerRadius(34)
            Text(L10n.checkYouInbox)
                .font(.poppins(.regular, size: 21))
                .multilineTextAlignment(.center)
        }
    }
    var openEmailAppLink: some View {
        NavigationLink {
            NewPasswordView(viewModel: viewModel)
        } label: {
            Text(L10n.openEmailApp)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.black)
                .foregroundColor(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
        }
    }
}

struct CheckInboxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInboxView(viewModel: UserViewModel())
    }
}
