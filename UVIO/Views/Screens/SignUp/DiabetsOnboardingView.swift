//
//  DiabetsOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI
import Resolver

struct DiabetsOnboardingView: View {
    @ObservedObject var diabetsViewModel: DiabetsOnboardingViewModel
    @Injected var viewModel: UserViewModel
    var body: some View {
        ZStack {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .bottom) {
                VStack(spacing: 16) {
                    Spacer()
                    contentView
                        .padding(.bottom)
                    NextButton(destination:
                                GlucoseUnitOnboardingView(glucoseViewModel: GlucoseUnitOnboardViewModel()))
                    SkipButton(destination: SignInView(viewModel: viewModel))
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
                ProgressView(completed: 0.8)
            }
        })
    }
    let columns = [
        GridItem(.flexible())
    ]
    var contentView: some View {
        VStack {
            Text(L10n.whichTypeDiabetes)
                .font(.poppins(.bold, size: 24))
            ScrollView([]) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(diabetsViewModel.diabetTypeList,
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
                                self.diabetsViewModel.selectedItem = item
                            }
                    }
                } .padding(.horizontal)
            }.frame(height: 430)
        }
    }
}
struct DiabetsOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        DiabetsOnboardingView(diabetsViewModel: DiabetsOnboardingViewModel())
    }
}
