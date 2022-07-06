//
//  BGLevelAlertView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct BGLevelAlertView: View {
    @StateObject var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            VStack {
                navigationBarView
                contentView
                Spacer()
                footerView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

struct BGLevelAlertView_Previews: PreviewProvider {
    static var previews: some View {
        BGLevelAlertView(viewModel: UserViewModel())
    }
}

extension BGLevelAlertView {
    var backgroundView: some View {
        Rectangle()
            .foregroundColor(Color.grayScaleColor)
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
    var navigationBarView: some View {
        NavigationBackBarViewAction(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            ZStack {
                Text(L10n.bgLevelAlerts)
                    .font(.poppins(.medium, size: 18))
            }
        }, backgroundColor: Color.white)
    }
    var contentView: some View {
        VStack(alignment: .leading) {
            Text(L10n.targetLevel)
                .font(.poppins(.bold, size: 18))
                .padding(.top)
            Text(L10n.takeBackControl)
                .font(.poppins(.medium, size: 14))
            targetRangeView
            notifyBGView
            Text(L10n.hypersAndHypos)
                .font(.poppins(.bold, size: 18))
                .padding(.top)
            Text(L10n.takeBackControl)
                .font(.poppins(.medium, size: 14))
            hypersAndHyposView
            alertBGView
        }
        .padding(.leading)
    }
    var targetRangeView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .frame(height: 116)
                .overlay(rangeSliderOverlay)
        }
        .padding(.trailing)
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
    var notifyBGView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .frame(height: 44)
                .overlay(notifyBGOverlay)
        }
        .padding(.trailing)
    }
    var notifyBGOverlay: some View {
        ZStack {
            HStack {
                Text(L10n.notifyBG)
                    .font(.poppins(.medium, size: 14))
                Spacer()
                Toggle("", isOn: $viewModel.notifyBGLevelOutOfRange)
                    .toggleStyle(CustomToggleStyle(color: Color.complementaryColor))
            }
            .padding(.horizontal)
        }
    }
    var hypersAndHyposView: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 224)
                    .foregroundColor(Color.white)
                    .overlay(doubleSliderOverlay)
            }
            .padding(.trailing)
        }
    }
    var doubleSliderOverlay: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 100)
                .overlay(topSliderOverlay)
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 100)
                .overlay(bottomSliderOverlay)
        }
        .foregroundColor(Color.clear)
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
                    Text(L10n.hyperHighGlucose)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(viewModel.hyperValue) \(viewModel.glucoseUnit)")
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
                    Text(L10n.hypoLowGlucose)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(viewModel.hypoValue) \(viewModel.glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryAlertColor)
                }
                SingleSliderView(value: $viewModel.hypoValue, bounds: 0...300)
            }
            .padding()
        }
    }
    var alertBGView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .frame(height: 44)
                .overlay(alertBGOverlay)
        }
        .padding(.trailing)
    }
    var alertBGOverlay: some View {
        ZStack {
            HStack {
                Text(L10n.alertHighLow)
                    .font(.poppins(.medium, size: 14))
                Spacer()
                Toggle("", isOn: $viewModel.alertBGLevelOutOfRange)
                    .toggleStyle(CustomToggleStyle(color: Color.complementaryColor))
            }
            .padding(.horizontal)
        }
    }
    var footerView: some View {
        ZStack {
            Button {
            } label: {
                HStack {
                    Image.checkMarkIcon
                    Text(L10n.save)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.complementaryColor)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .frame(height: 100)
            .background(Color.white)
        }
    }
}
