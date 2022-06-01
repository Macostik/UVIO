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
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .bottom) {
                VStack(spacing: 16) {
                    Spacer()
                    contentView
                    Spacer()
                    NavigationLink(isActive: $viewModel.userCreateCompleted) {
                        SignUpView(viewModel: viewModel)
                    } label: {
                        EmptyView()
                    }
                    Button(action: {
                        viewModel.createNewUser.send(User())
                    }, label: {
                        ZStack {
                            HStack {
                                Image.checkMarkIcon
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
                        .background(Color.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .overlay(textOverlay)
                    })
                    .padding(.bottom, 30)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                ProgressView(completed: 1.0)
            }
        })
    }
}

struct GlucoseAlertOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseAlertOnboardingView(viewModel: UserViewModel())
    }
}

extension GlucoseAlertOnboardingView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            targetView
            hypersAndHypos
        }
    }
    var targetView: some View {
        VStack(alignment: .leading) {
            Text(L10n.targetLevel)
                .font(.poppins(.bold, size: 18))
            Text(L10n.takeBackControl)
                .font(.poppins(.medium, size: 14))
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 116)
                    .foregroundColor(Color.white)
                    .overlay(rangeSliderOverlay)
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    var rangeSliderOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
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
                    Text(L10n.hyperHighGlucose)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(viewModel.hyperValue) \(viewModel.glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryAlertColor)
                }
                SingleSliderView(value: $viewModel.hyperValue, bounds: 0...300)
            }.padding()
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
                        .rotationEffect(.radians(.pi))
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
    var hypersAndHypos: some View {
        VStack(alignment: .leading) {
            Text(L10n.hypersAndHypos)
                .font(.poppins(.bold, size: 18))
            Text(L10n.takeBackControl)
                .font(.poppins(.medium, size: 14))
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 224)
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
                .overlay(topSliderOverlay)
                .padding(.top, 8)
            RoundedRectangle(cornerRadius: 12)
                .overlay(bottomSliderOverlay)
                .padding(.bottom, 8)
        }
        .foregroundColor(Color.clear)
    }
    var textOverlay: some View {
        Text(L10n.complete)
            .font(.poppins(.medium, size: 14))
            .foregroundColor(.white)
    }
}
