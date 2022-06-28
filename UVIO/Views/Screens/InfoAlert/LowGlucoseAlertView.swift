//
//  LowGlucoseAlertView.swift
//  UVIO
//
//  Created by Macostik on 28.06.2022.
//

import SwiftUI

struct LowGlucoseAlertView: View {
    @StateObject var viewModel: MainViewModel
    @State var isCarbsOverlayOpen = false
    var body: some View {
        contentView
    }
}

struct LowGlucoseAlertView_Previews: PreviewProvider {
    static var previews: some View {
        LowGlucoseAlertView(viewModel: MainViewModel())
    }
}

extension LowGlucoseAlertView {
    var contentView: some View {
        VStack {
            Image.waringIcon
                .padding(.bottom, 5)
            Text(L10n.lowGlucoseAlert)
                .foregroundColor(Color.primaryAlertColor)
                .font(.poppins(.bold, size: 18))
                .padding(.bottom, 5)
            Text(L10n.bloodSugarIsLow)
                .foregroundColor(Color.black)
                .font(.poppins(.regular, size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            foodContainer
            carbsContainer
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
            } label: {
                Text(L10n.skipForNow)
                    .foregroundColor(Color.black)
                    .font(.poppins(.medium, size: 14))
            }
            .padding(.top, 12)

        }
    }
    var foodContainer: some View {
        VStack {
            if isCarbsOverlayOpen {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(
                        Picker("", selection: $viewModel.foodCarbs) {
                            ForEach(CarbsPickerData.allCases, id: \.self) {
                                Text($0.description)
                            }
                        }
                        .pickerStyle(.wheel)
                    )
                    .frame(height: 156)
                    .padding(.horizontal)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(foodOverlay, alignment: .leading)
                    .frame(height: 48)
                    .padding(.horizontal)
            }
        }
    }
    var carbsContainer: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color.white)
            .overlay(carbsOverlay, alignment: .leading)
            .frame(height: 48)
            .padding(.horizontal)
    }
    var buttonOverlay: some View {
        Text(L10n.logCorrection)
            .foregroundColor(Color.white)
            .font(.poppins(.medium, size: 14))
    }
    var foodOverlay: some View {
        HStack {
            Text(L10n.foodEaten)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.foodNameAlert)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var carbsOverlay: some View {
        Button {
            isCarbsOverlayOpen.toggle()
        } label: {
            HStack {
                Text(L10n.carbs)
                    .font(.poppins(.medium, size: 14))
                Text(viewModel.foodCarbs.description)
                    .font(.poppins(.bold, size: 14))
            }
            .foregroundColor(Color.black)
            .padding()
        }
    }
}
