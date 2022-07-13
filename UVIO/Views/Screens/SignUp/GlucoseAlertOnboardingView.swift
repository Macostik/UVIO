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
                NextButton(destination: CompleteOnboardingView(viewModel: viewModel))
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
        VStack(alignment: .leading, spacing: 8) {
            targetView
            hypersAndHypos
        }
    }
    var targetView: some View {
        VStack {
            Text(L10n.setGlucoseAlert)
                .font(.poppins(.bold, size: 24))
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .frame(height: 116)
                    .overlay(rangeSliderOverlay)
            }
            .padding(.trailing)
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
                RangedSliderView(value: $viewModel.glucoseRangeValue,
                                 bounds: 0...300)
            }.padding()
        }
    }
    var topSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.grayLightColor)
                .padding(.horizontal, 8)
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
                SingleSliderView(value: $viewModel.hyperValue, bounds: 0...300)
            }
            .padding()
        }
    }
    var bottomSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.grayLightColor)
                .padding(.horizontal, 8)
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
                SingleSliderView(value: $viewModel.hypoValue, bounds: 0...300)
            }
            .padding()
        }
    }
    var hypersAndHypos: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 396)
                    .foregroundColor(Color.white)
                    .overlay(doubleSliderOverlay)
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    var doubleSliderOverlay: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 100)
                .overlay(topSliderOverlay)
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 100)
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
                        .toggleStyle(CustomToggleStyle())
                }
                Text(L10n.turnOnArerts)
                    .font(.poppins(.medium, size: 10))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 28)
            }
            Divider()
                .padding(.leading, 40)
            VStack {
                VStack(alignment: .leading) {
                HStack {
                    Image.timerIcon
                    Text(L10n.dontDisturb)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(L10n.off)
                        .font(.poppins(.medium, size: 12))
                        .foregroundColor(Color.black)
                    Toggle("", isOn: $viewModel.isNotDisturb)
                        .toggleStyle(CustomToggleStyle())
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
