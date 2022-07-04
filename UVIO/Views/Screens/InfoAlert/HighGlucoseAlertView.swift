//
//  HighGlucoseAlertView.swift
//  UVIO
//
//  Created by Macostik on 27.06.2022.
//

import SwiftUI

struct HighGlucoseAlertView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
      contentView
    }
}

struct InputInsulinView_Previews: PreviewProvider {
    static var previews: some View {
        HighGlucoseAlertView(viewModel: MainViewModel())
    }
}

extension HighGlucoseAlertView {
    var contentView: some View {
        VStack {
            Image.waringIcon
            Text(L10n.highGlucoseAlert)
                .foregroundColor(Color.primaryAlertColor)
                .font(.poppins(.bold, size: 18))
            Text(L10n.bloodSugarIsHigh)
                .foregroundColor(Color.black)
                .font(.poppins(.regular, size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            CounterView(counter: $viewModel.highAlertCounterValue,
                        unit: .constant(L10n.unitsInsulin),
                        color: .constant(Color.white.opacity(0.4)),
                        buttonColor: .constant(Color.white), isInvertedColor: true)
            Button {
                viewModel.presentAlertItem = .checkInTime
            } label: {
                ZStack {
                    HStack {
                        Image.nextIcon
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
        Text(L10n.logCorrection)
            .foregroundColor(Color.white)
            .font(.poppins(.medium, size: 14))
    }
}
