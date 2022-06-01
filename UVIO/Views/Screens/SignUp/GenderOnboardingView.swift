//
//  GenderOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct GenderOnboardingView: View, Identifiable {
    let id = UUID()
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                Spacer()
                contentView
                Spacer()
                SkipButton(destination: SignUpView(viewModel: viewModel))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
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
                            .overlay(genderOverlay(type: item.type)
                                .foregroundColor( item.isSelected ? Color.white : Color.black))
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
    }
    func genderOverlay(type: String) -> some View {
        Text(type)
            .font(.poppins(.bold, size: 14))
    }
}

struct GenderOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GenderOnboardingView(viewModel: UserViewModel())
    }
}
