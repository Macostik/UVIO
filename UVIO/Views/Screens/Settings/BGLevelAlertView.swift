//
//  BGLevelAlertView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct BGLevelAlertView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State var showFooter = false
    @State var isSaved = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            VStack {
                navigationBarView
                contentView
                Spacer()
                if showFooter {
                    footerView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.appearBGLevel.send()
        }
    }
}

struct BGLevelAlertView_Previews: PreviewProvider {
    static var previews: some View {
        BGLevelAlertView()
    }
}

extension BGLevelAlertView {
    var backgroundView: some View {
        Rectangle()
            .foregroundColor(Color.graySettingsColor)
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
            targetRangeView
            hypersAndHypos
        }
    }
    var targetRangeView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .frame(height: 116)
                .overlay(rangeSliderOverlay)
        }
        .padding(.horizontal)
        .padding(.top, 5)
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
                .onChange(of: viewModel.glucoseRangeValue) { _ in
                    withAnimation {
                        showFooter = true
                    }
                }
                .padding(.horizontal, 10)
            }.padding()
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
        .padding(.top, 4)
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
    var topSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.grayLightColor)
                .padding(.top, 2)
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
                    .onChange(of: viewModel.hypoValue) { _ in
                        withAnimation {
                            showFooter = true
                        }
                    }
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
                .onChange(of: viewModel.hyperValue) { _ in
                    withAnimation {
                        showFooter = true
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding()
            .padding(.top, -4)
        }
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
                        .onChange(of: viewModel.isVibrate) { _ in
                            withAnimation {
                                showFooter = true
                            }
                        }
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
                        .onChange(of: viewModel.isNotDisturb) { _ in
                            withAnimation {
                                showFooter = true
                            }
                        }
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
    var footerView: some View {
        ZStack {
            Button {
                isSaved = true
                viewModel.saveBGLevelsData.send()
                withAnimation {
                    showFooter = false
                }
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
                .padding(.bottom, 20)
            }
            .frame(height: 100)
            .background(Color.white)
        }
    }
}
