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
            VStack {
                Spacer()
                container
                Spacer()
                openEmailAppLink
            }
        }
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
        Button {
            self.viewModel.presentLoginView.value = .newPassword
        } label: {
            Text(L10n.openEmailApp)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.complementaryColor)
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
