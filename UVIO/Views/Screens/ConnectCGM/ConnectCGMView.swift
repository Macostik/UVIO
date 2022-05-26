//
//  ConnectCGMView.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import SwiftUI

struct ConnectCGMView: View {
    @ObservedObject var viewModel: ConnectCGMViewModel
    var body: some View {
        ZStack {
            VStack {
                NativigationBarView {}
                    .padding(.top, 50)
                VStack(spacing: 8) {
                    mainContainer
                    subContainer
                        .opacity(0.5)
                    subContainer
                        .opacity(0.3)
                    subContainer
                        .opacity(0.1)
                    Spacer()
                }
            }
//            welcomeContent
//                .opacity(viewModel.isHidden ? 0 : 1)
        }
        .background(Color.grayBackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
    var welcomeContent: some View {
        ZStack {
            Image.loginViewBackground
                .resizable()
            Text(L10n.welcome)
                .font(.poppins(.medium, size: 32))
                .foregroundColor(Color.complementaryColor)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    var mainContainer: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.white)
                .aspectRatio(contentMode: ContentMode.fit)
                .overlay(mainContainerOverlay)
        }
        .padding()
    }
    var mainContainerOverlay: some View {
        VStack {
            Image.connectCGMIcon
            Text(L10n.willConnectCGM)
                .font(.poppins(.regular, size: 14))
                .foregroundColor(Color.complementaryColor)
        }
    }
    var subContainer: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, maxHeight: 68)
            .padding(.horizontal)
            .overlay(subContainerOverlay)
    }
    var subContainerOverlay: some View {
        HStack {
            VStack(alignment: .leading) {
                Capsule()
                    .foregroundColor(Color.capsulaGrayColor)
                    .frame(width: 120, height: 10)
                Capsule()
                    .foregroundColor(Color.capsulaGrayColor)
                    .frame(width: 70, height: 10)
            }
            Spacer()
            Capsule()
                .foregroundColor(Color.capsulaGrayColor)
                .frame(width: 58, height: 28)

        }.padding(.horizontal, 34)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectCGMView(viewModel: ConnectCGMViewModel())
    }
}