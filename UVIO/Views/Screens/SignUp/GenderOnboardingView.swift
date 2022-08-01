//
//  GenderOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct GenderOnboardingView: View, Identifiable {
    @ObservedObject var viewModel: UserViewModel
    let id = UUID()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                Spacer()
                contentView
                Spacer()
                SkipButton(destination: CompleteOnboardingView(viewModel: viewModel))
                    .padding(.bottom, 7)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GenderOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GenderOnboardingView(viewModel: UserViewModel())
    }
}

extension GenderOnboardingView {
    var contentView: some View {
        VStack(spacing: 32) {
            Text(L10n.whatIsYourGender)
                .font(.poppins(.bold, size: 24))
            ScrollView([]) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(genderTypeList,
                            id: \.id) { item in
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(item.isSelected ? Color.complementaryColor : Color.white)
                            .frame(height: 80)
                            .overlay(
                                Text(item.type)
                                .foregroundColor( item.isSelected ? Color.white : Color.black)
                                .font(.poppins(item.isSelected ? .bold : .medium, size: 14))
                            )
                            .onTapGesture {
                                self.viewModel.genderSelectedItem = item
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    viewModel.presentOnboardingView.value = .glucoseUnit
                                })
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 175)
        }
        .offset(y: -20)
    }
}
