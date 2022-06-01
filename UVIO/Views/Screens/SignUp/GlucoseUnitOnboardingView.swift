//
//  GlucoseUnitOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 01.06.2022.
//

import SwiftUI

struct GlucoseUnitOnboardingView: View {
    @ObservedObject var viewModel: UserViewModel
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                contentView
                Spacer()
                SkipButton(destination: SignUpView(viewModel: viewModel))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    var contentView: some View {
        VStack(spacing: 32) {
            Text(L10n.selectGlucose)
                .font(.poppins(.bold, size: 24))
                .multilineTextAlignment(.center)
            HStack {
                ScrollView([]) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(glucoseTypeList,
                                id: \.id) { item in
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(item.isSelected ? Color.complementaryColor : Color.white)
                                .frame(height: 48)
                                .overlay(
                                    HStack {
                                        Text(item.type)
                                            .foregroundColor(item.isSelected ? Color.white : Color.black)
                                            .font(.poppins(.medium, size: 14))
                                            .padding(.leading)
                                        Spacer()
                                    }
                                )
                                .onTapGesture {
                                    self.viewModel.glucoseSelectedItem = item
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        viewModel.presentOnboardingView.value = .glucoseAlert
                                    })
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 48)
            }
        }.padding(.top)
    }
}

struct GlucoseUnitOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseUnitOnboardingView(viewModel: UserViewModel())
    }
}
