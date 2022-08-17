//
//  GlucoseAlertOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

struct GlucoseAlertOnboardingView: View, Identifiable {
    let id = UUID()
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                contentView
                Spacer()
                NextButton(destination: CompleteOnboardingView())
                    .padding(.bottom, 6)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GlucoseAlertOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseAlertOnboardingView(viewModel: UserViewModel())
    }
}

extension GlucoseAlertOnboardingView {
    var contentView: some View {
        VStack(alignment: .leading) {
            targetView
            hypersAndHypos
        }
    }
    var targetView: some View {
        VStack {
            Text(L10n.setGlucoseAlert)
                .font(.poppins(.bold, size: 24))
                .padding(.top, -7)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.white)
                    .frame(height: 116)
                    .overlay(rangeSliderOverlay)
            }
            .padding(.trailing)
            .padding(.top, 15)
        }
        .padding(.leading)
    }
    var rangeSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 100)
                .foregroundColor(Color.grayLightColor)
                .padding(8)
            VStack(spacing: 0) {
                HStack {
                    Image.greenArrowIcon
                    Text(L10n.targetRange)
                        .font(.poppins(.medium, size: 14))
                    Spacer()
                    Text("\(viewModel.glucoseRangeValue.lowerBound)-" +
                         "\(viewModel.glucoseRangeValue.upperBound) \(viewModel.glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryGreenColor)
                }
                .padding(.horizontal, 8)
                RangedSliderView(value: $viewModel.glucoseRangeValue,
                                 bounds: 0...300)
                .padding(.horizontal, 10)
            }.padding()
        }
    }
    var topSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.grayLightColor)
                .padding(.top, 6)
                .padding(.horizontal, 8)
                .frame(height: 108)
            VStack(spacing: 0) {
                HStack {
                    Image.alertArrowIcon
                        .rotationEffect(.radians(.pi))
                    Text(L10n.lowGlucoseAlarm)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("<\(viewModel.hypoValue) \(viewModel.glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryAlertColor)
                }
                .padding(.horizontal, 8)
                SingleSliderView(value: $viewModel.hypoValue, bounds: 0...300)
                    .padding(.horizontal, 10)
            }
            .padding()
        }
    }
    var bottomSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.grayLightColor)
                .padding(.horizontal, 8)
                .frame(height: 108)
            VStack(spacing: 0) {
                HStack {
                    Image.alertArrowIcon
                    Text(L10n.highGlucoseAlarm)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(">\(viewModel.hyperValue) \(viewModel.glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryAlertColor)
                }
                .padding(.horizontal, 8)
                SingleSliderView(value: $viewModel.hyperValue,
                                 bounds: 0...300,
                                 invertColor: true)
                .padding(.horizontal, 10)
            }
            .padding()
            .padding(.top, -4)
        }
    }
    var hypersAndHypos: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 408)
                    .foregroundColor(Color.white)
                    .overlay(doubleSliderOverlay)
            }
            .padding(.trailing)
        }
        .padding(.leading)
        .padding(.top, 6)
    }
    var doubleSliderOverlay: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 108)
                .overlay(topSliderOverlay)
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 108)
                .overlay(bottomSliderOverlay)
                .padding(.bottom, 8)
            vibrateView
                .padding(.horizontal, 16)
        }
        .foregroundColor(Color.clear)
    }
    var textOverlay: some View {
        Text(L10n.complete)
            .font(.poppins(.medium, size: 14))
            .foregroundColor(.white)
    }
    var vibrateView: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image.vibrateIcon
                    Text(L10n.vibrateOnly)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(L10n.off)
                        .font(.poppins(.medium, size: 12))
                        .foregroundColor(Color.black)
                    Toggle("", isOn: $viewModel.isVibrate)
                        .toggleStyle(
                            CustomToggleStyle(color: Color.complementaryColor))
                }
                Text(L10n.turnOnArerts)
                    .font(.poppins(.medium, size: 10))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 28)
            }
            Divider()
                .padding(.leading, 30)
            VStack {
                VStack(alignment: .leading) {
                HStack {
                    Image.alertTimeIcon
                    Text(L10n.dontDisturb)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(L10n.off)
                        .font(.poppins(.medium, size: 12))
                        .foregroundColor(Color.black)
                    Toggle("", isOn: $viewModel.isNotDisturb)
                        .toggleStyle(
                            CustomToggleStyle(color: Color.complementaryColor))
                }
                Text(L10n.turnOnDisturbMode)
                    .font(.poppins(.medium, size: 10))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 28)
                }
                .padding(.bottom, 8)
            }
        }
    }
}
