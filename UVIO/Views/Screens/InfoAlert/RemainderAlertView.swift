//
//  RemainderAlertView.swift
//  UVIO
//
//  Created by Macostik on 28.06.2022.
//

import SwiftUI

struct RemainderAlertView: View {
    @StateObject var viewModel: MainViewModel
    var body: some View {
        contentView
    }
}

struct RemainderAlertView_Previews: PreviewProvider {
    static var previews: some View {
        RemainderAlertView(viewModel: MainViewModel())
    }
}

extension RemainderAlertView {
    var contentView: some View {
        VStack {
            Image.remainderIcon
            Text(L10n.setReminder)
                .foregroundColor(Color.black)
                .font(.poppins(.bold, size: 18))
            Text(L10n.checkYourGlucose)
                .foregroundColor(Color.black)
                .font(.poppins(.regular, size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            CounterView(counter: $viewModel.reminderAlertCounterValue,
                        unit: .constant(L10n.minutes),
                        color: .constant(Color.white.opacity(0.4)),
                        buttonColor: .constant(Color.white), isInvertedColor: true)
            Button {
                viewModel.isShownWarningAlert = true
            } label: {
                ZStack {
                    HStack {
                        Image.checkMarkIcon
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
                .background(Color.complementaryColor)
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(buttonOverlay)
                .padding(.top, 15)
            }
            Button {
                withAnimation {
                    viewModel.isShowInfoAlert = false
                }
            } label: {
                Text(L10n.skipForNow)
                    .foregroundColor(Color.black)
                    .font(.poppins(.medium, size: 14))
            }
            .padding(.top, 12)

        }
    }
    var buttonOverlay: some View {
        Text(L10n.setReminder)
            .foregroundColor(Color.white)
            .font(.poppins(.medium, size: 14))
    }
}
