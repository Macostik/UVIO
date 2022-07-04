//
//  CompleteOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 01.06.2022.
//

import SwiftUI

struct CompleteOnboardingView: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundColor
                .ignoresSafeArea()
            VStack {
                Spacer()
                contentView
                Spacer()
            }
            NavigationBarView(destination: {
                EmptyView()
            }, content: {})
            NavigationLink(isActive: $viewModel.userCreateCompleted) {
                MainView(viewModel: MainViewModel())
            } label: {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct CompleteOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteOnboardingView(viewModel: UserViewModel())
    }
}

extension CompleteOnboardingView {
    var backgroundColor: some View {
        LinearGradient(
            colors: [Color.grayBackgroundColor],
            startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
    var contentView: some View {
        VStack {
            Image.successMarkIcon
                .padding(.bottom, 22)
            Text(L10n.awosomeYouMadeIt)
                .font(.poppins(.bold, size: 24))
                .padding(.bottom, 40)
            letsConnectText
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 43)
            completeButton
        }
    }
    var completeButton: some View {
        Button {
            viewModel.dexcomLogin()
        } label: {
            Text(L10n.connectDexcom)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(Color.complementaryColor)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    var letsConnectText: some View {
        Text(L10n.letsConnectDexcom)
            .font(.poppins(.regular, size: 21)) +
        Text(L10n.dexcom)
            .font(.poppins(.bold, size: 21)) +
        Text(L10n.getStarted)
            .font(.poppins(.regular, size: 21))
    }
}
