//
//  WarningAlertView.swift
//  UVIO
//
//  Created by Macostik on 29.06.2022.
//

import SwiftUI

struct WarningAlertView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        contentView
    }
}

struct WarningAlertView_Previews: PreviewProvider {
    static var previews: some View {
        WarningAlertView()
    }
}

extension WarningAlertView {
    var contentView: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 32)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 340)
                .overlay(contentOverlay)
                .padding(.horizontal, 10)
            Spacer()
        }
    }
    var contentOverlay: some View {
        VStack(spacing: 12) {
            Text(L10n.warning)
                .foregroundColor(Color.black)
                .font(.poppins(.bold, size: 21))
            Text(L10n.testModeWarning)
                .foregroundColor(Color.black)
                .font(.poppins(.regular, size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button {
                viewModel.isShownWarningAlert = false
            } label: {
                ZStack {
                    Text(L10n.understandRisk)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 48)
                        .background(Color.complementaryColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            Button {
                viewModel.isShownWarningAlert = false
            } label: {
                ZStack {
                    Text(L10n.close)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 14))
                }
            }
            .padding(.top)
        }
    }
}
