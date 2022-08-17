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
            .transition(.move(edge: .bottom))
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
            .overlay(
                Group {
                    if viewModel.selectedInfoAlertItem == .reminder {
                        Image.alertBackgroundBlue.resizable()
                    } else if viewModel.selectedInfoAlertItem == .checkInTime {
                        Image.alertBackgroundGreen.resizable()
                    } else {
                        Image.alertBackgroundRed.resizable()
                    }
                }
            )
            .overlay(bottomInfoAlertOverlay, alignment: .top)
            .padding(.horizontal, 8)
            .padding(.bottom, safeAreaInsets.bottom - 10)
    }
    var bottomInfoAlertOverlay: some View {
        ZStack {
            TabView(selection: $viewModel.selectedInfoAlertItem) {
                HighGlucoseAlertView(viewModel: viewModel)
                    .tag(InfoAlertType.inputValue)
                CheckInTimeView(viewModel: viewModel)
                    .tag(InfoAlertType.checkInTime)
                //                LowGlucoseAlertView(viewModel: viewModel)
                //                    .tag(InfoAlertType.inputValue)
                RemainderAlertView(viewModel: viewModel)
                    .tag(InfoAlertType.reminder)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .padding(.top)
    }
}
