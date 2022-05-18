//
//  GenderOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct GenderOnboardingView: View {
    
    @ObservedObject private var viewModel: GenderOnboardingViewModel
    
    init(viewModel: GenderOnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image("loginViewBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .bottom) {
                VStack(spacing: 16) {
                    Spacer()
                    contentView
                    Spacer()
                    nextButton(destination: DiabetsOnboardingView(viewModel: DiabetsOnboardingViewModel()))
                    skipButton()
                        .padding(.bottom, 30)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                progressView(completed: 0.6)
            }
        })
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var contentView: some View {
        VStack {
            Text("What is your Gender?")
                .font(.custom("Poppins-Bold", size: 24))
            ScrollView([]) {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.genderTypeList,
                            id: \.id) { item in
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(item.isSelected ? Color.clear : Color.white)
                            .frame(height: 80)
                            .overlay(genderOverlay(type: item.type)
                                .foregroundColor( item.isSelected ? Color("complementaryColor") : Color.black))
                            .overlay( RoundedRectangle(cornerRadius: 16.0)
                                .stroke(lineWidth: item.isSelected ? 2.0 : 0.0)
                                .foregroundColor(Color.white))
                            .onTapGesture {
                                self.viewModel.selectedItem = item
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 175)
            if viewModel.isSelectedSpecifyType {
                TextField("Provide own", text: $viewModel.ownType)
                    .font(.custom("Poppins-Medium", size: 14))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding()
            }
        }
    }
    
    func genderOverlay(type: String) -> some View {
        Text(type)
            .font(.custom("Poppins-Bold", size: 14))
    }
}

struct GenderOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GenderOnboardingView(viewModel: GenderOnboardingViewModel())
    }
}
