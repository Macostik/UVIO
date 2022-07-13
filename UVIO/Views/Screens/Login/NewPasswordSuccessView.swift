//
//  NewPasswordSuccessView.swift
//  UVIO
//
//  Created by Macostik on 24.05.2022.
//

import SwiftUI

struct NewPasswordSuccessView: View {
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
        VStack(spacing: 18) {
            Image.successMarkIcon
                .frame(width: 68, height: 68)
                .aspectRatio(contentMode: .fill)
            Text(L10n.successfullyChangedPassword)
                .font(.poppins(.medium, size: 18))
                .multilineTextAlignment(.center)
        }
    }
    var openEmailAppLink: some View {
        NavigationLink {
            SignUpFlow(viewModel: viewModel)
        } label: {
            Text(L10n.signIn)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.complementaryColor)
                .foregroundColor(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
}

struct NewPasswordSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        NewPasswordSuccessView(viewModel: UserViewModel())
    }
}
