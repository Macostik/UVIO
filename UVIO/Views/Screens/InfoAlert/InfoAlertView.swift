//
//  InfoAlertView.swift
//  UVIO
//
//  Created by Macostik on 27.06.2022.
//

import SwiftUI

struct InfoAlertView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        infoAlertView
    }
}
struct InfoAlertView_Previews: PreviewProvider {

    static var previews: some View {
        InfoAlertView(viewModel: MainViewModel())
    }
}

extension InfoAlertView {
    var infoAlertView: some View {
        RoundedRectangle(cornerRadius: 35)
            .frame(width: .infinity, height: 412)
            .overlay(Image.alertBackgroundRed.resizable())
            .overlay(bottomInfoAlertOverlay, alignment: .top)
            .padding(.horizontal)
            .padding(.bottom, safeAreaInsets.bottom - 15)
    }
    var bottomInfoAlertOverlay: some View {
        ZStack {
            TabView(selection: $viewModel.selectedInfoAlertItem) {
                LowGlucoseAlertView(viewModel: viewModel)
                    .tag(InfoAlertType.inputValue)
//                HighGlucoseAlertView(viewModel: viewModel)
//                    .tag(InfoAlertType.inputValue)
//                CheckInTimeView(viewModel: viewModel)
//                    .tag(InfoAlertType.checkInTime)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.top)
    }
}