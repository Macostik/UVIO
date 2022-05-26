//
//  GenderOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct GenderOnboardingView: View {
    @ObservedObject var genderViewModel: GenderOnboardingViewModel
    @ObservedObject var viewModel: UserViewModel
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
                    NextButton(destination:
                                DiabetsOnboardingView(diabetsViewModel: DiabetsOnboardingViewModel(),
                                                      viewModel: viewModel))
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
                ProgressView(completed: 0.6)
            }
        })
    }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var contentView: some View {
        VStack {
            Text(L10n.whatIsYourGender)
                .font(.poppins(.bold, size: 24))
            ScrollView([]) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(genderViewModel.genderTypeList,
                            id: \.id) { item in
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(item.isSelected ? Color.clear : Color.white)
                            .frame(height: 80)
                            .overlay(genderOverlay(type: item.type)
                                .foregroundColor( item.isSelected ? Color.complementaryColor : Color.black))
                            .overlay( RoundedRectangle(cornerRadius: 16.0)
                                .stroke(lineWidth: item.isSelected ? 2.0 : 0.0)
                                .foregroundColor(Color.white))
                            .onTapGesture {
                                self.genderViewModel.selectedItem = item
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 175)
            if genderViewModel.isSelectedSpecifyType {
                TextField(L10n.provideOwn, text: $genderViewModel.ownType)
                    .font(.poppins(.medium, size: 14))
                    .padding(.leading)
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 10)
            }
        }
    }
    func genderOverlay(type: String) -> some View {
        Text(type)
            .font(.poppins(.bold, size: 14))
    }
}

struct GenderOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GenderOnboardingView(genderViewModel: GenderOnboardingViewModel(), viewModel: UserViewModel())
    }
}
