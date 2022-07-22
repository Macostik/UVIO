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
                connectButton
            }
            NavigationBarView(destination: {
                EmptyView()
            }, content: {})
            NavigationLink(isActive: $viewModel.userCreateCompleted) {
                MainView(userViewModel: viewModel,
                         mainViewModel: MainViewModel())
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
                .padding(.bottom, -15)
            Text(L10n.awesomeYouMadeIt)
                .font(.poppins(.bold, size: 24))
                .padding(.bottom, 5)
            letsConnectText
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 60)
    }
    var connectButton: some View {
        Button {
            viewModel.dexcomLogin()
        } label: {
            ZStack {
                HStack {
                    Image.nextIcon
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
            .background(Color.complementaryColor)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(
                Text(L10n.connectDexcom)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(.white)
            )
        }
        .padding(.bottom, 40)
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
