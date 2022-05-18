//
//  GlucoseUnitOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

struct GlucoseUnitOnboardingView: View {
    
    @ObservedObject private var viewModel: GlucoseUnitOnboardViewModel
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    init(viewModel: GlucoseUnitOnboardViewModel) {
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
                    completeButton(destination: DiabetsOnboardingView(viewModel: DiabetsOnboardingViewModel()))
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
                progressView(completed: 1.0)
            }
        })
    }
}


struct GlucoseUnitOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GlucoseUnitOnboardingView(viewModel: GlucoseUnitOnboardViewModel())
    }
}

extension GlucoseUnitOnboardingView {
    var contentView: some View {
        VStack(alignment: .leading) {
            glucoseView
            targetView
        }
    }
    
    var glucoseView: some View {
        VStack(alignment: .leading) {
            Text("Blood glucose unit")
                .font(.custom("Poppins-Bold", size: 18))
                .padding(.leading)
            HStack {
                ScrollView([]) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.glucoseTypeList,
                                id: \.id) { item in
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(item.isSelected ? Color.clear : Color.white)
                                .frame(height: 48)
                                .overlay(genderOverlay(type: item.type, isSelected: item.isSelected)
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
                .frame(height: 48)
            }
        }
    }
    
    var targetView: some View {
        VStack(alignment: .leading) {
            Text("Target level")
                .font(.custom("Poppins-Bold", size: 18))
            Text("Take back the Control over your Diabetes")
                .font(.custom("Poppins-Medium", size: 14))
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 116)
                    .foregroundColor(Color.white)
                    .overlay(container)
            }
            .padding(.trailing)
        }
        .padding(.leading)
    }
    
    var container: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("grayLightColor"))
                .padding(8)
            VStack {
                HStack {
                    Image("targetArrowIcon")
                    Text("Target range")
                        .font(.custom("Poppins-Medium", size: 14))
                    Spacer()
                    Text("\(viewModel.glucoseRangeValue.lowerBound)-\(viewModel.glucoseRangeValue.upperBound) mg/dL")
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(Color("primaryGreenColor"))
                }
                
                RangedSliderView(value: $viewModel.glucoseRangeValue,
                                 bounds: 0...300)
            }.padding()
            
        }
    }
    
    struct completeButton<V: View>: View {
        
        private var destination: V
        
        init(destination: V) {
            self.destination = destination
        }
        
        var body: some View {
            NavigationLink(destination: destination) {
                ZStack {
                    HStack() {
                        Image("checkMarkIcon")
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
            Text("Complete")
                .font(.custom("Popping-Medium", size: 14))
                .foregroundColor(.white)
        }
    }
}


