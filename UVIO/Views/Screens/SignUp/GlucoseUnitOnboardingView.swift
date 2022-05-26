//
//  GlucoseUnitOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

struct GlucoseUnitOnboardingView: View {
    @ObservedObject var glucoseViewModel: GlucoseUnitOnboardViewModel
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
                    CompleteButton(destination: SignUpView(viewModel: viewModel))
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

struct GlucoseUnitOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseUnitOnboardingView(glucoseViewModel: GlucoseUnitOnboardViewModel(), viewModel: UserViewModel())
    }
}

extension GlucoseUnitOnboardingView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 15) {
            glucoseView
            targetView
            hypersAndHypos
        }
    }
    var glucoseView: some View {
        VStack(alignment: .leading) {
            Text(L10n.bloodGlucoseUnit)
                .font(.poppins(.bold, size: 18))
                .padding(.leading)
            HStack {
                ScrollView([]) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(glucoseViewModel.glucoseTypeList,
                                id: \.id) { item in
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(item.isSelected ? Color.clear : Color.white)
                                .frame(height: 48)
                                .overlay(genderOverlay(type: item.type, isSelected: item.isSelected)
                                    .foregroundColor( item.isSelected ? Color.complementaryColor : Color.black))
                                .overlay( RoundedRectangle(cornerRadius: 16.0)
                                    .stroke(lineWidth: item.isSelected ? 2.0 : 0.0)
                                    .foregroundColor(Color.white))
                                .onTapGesture {
                                    self.glucoseViewModel.selectedItem = item
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 48)
            }
        }.padding(.top)
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
                    Text("\(glucoseViewModel.glucoseRangeValue.lowerBound)-" +
                         "\(glucoseViewModel.glucoseRangeValue.upperBound) \(glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryGreenColor)
                }
                RangedSliderView(value: $glucoseViewModel.glucoseRangeValue,
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
                    Text("\(glucoseViewModel.hyperValue) \(glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryAlertColor)
                }
                SingleSliderView(value: $glucoseViewModel.hyperValue, bounds: 0...300)
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
                    Text("\(glucoseViewModel.hypoValue) \(glucoseUnit)")
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.primaryAlertColor)
                }
                SingleSliderView(value: $glucoseViewModel.hypoValue, bounds: 0...300)
            }
            .padding()
        }
    }
    var glucoseUnit: String {
        glucoseViewModel.selectedItem?.type ?? L10n.mgDL
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
    struct CompleteButton<V: View>: View {
        private var destination: V
        init(destination: V) {
            self.destination = destination
        }
        var body: some View {
            NavigationLink(destination: destination) {
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
            }
        }
        var textOverlay: some View {
            Text(L10n.complete)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.white)
        }
    }
}
