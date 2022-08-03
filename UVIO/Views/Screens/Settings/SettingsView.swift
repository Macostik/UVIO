//
//  SettingsView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView
            navigationBarView
            contentView
        }
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = true
        }
        .navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: UserViewModel())
    }
}

extension SettingsView {
    var backgroundView: some View {
        Image.loginViewBackground
            .resizable()
            .ignoresSafeArea()
    }
    var navigationBarView: some View {
        NavigationBackBarViewAction(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {})
    }
    var contentView: some View {
        VStack(alignment: .leading) {
            Text(L10n.menu)
                .font(.poppins(.bold, size: 24))
                .padding(.top, 79)
            VStack(alignment: .leading, spacing: 30) {
                NavigationLink {
                     AccountInformationView(viewModel: viewModel)
                } label: {
                    HStack(spacing: 15) {
                        Image.accountInfoIcon
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(L10n.accountInformation)
                            .font(.poppins(.medium, size: 21))
                    }
                    .offset(x: -2)
                }
                NavigationLink {
                     BGLevelAlertView(viewModel: viewModel)
                } label: {
                    HStack(spacing: 15) {
                        Image.bgAlertIcon
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(L10n.bgLevelAlerts)
                            .font(.poppins(.medium, size: 21))
                    }
                }
                NavigationLink {
                     IntegrationsView(viewModel: viewModel)
                } label: {
                    HStack(spacing: 15) {
                        Image.devicesIcon
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(L10n.integrations)
                            .font(.poppins(.medium, size: 21))
                    }
                }
            }
            .foregroundColor(Color.black)
            .font(.poppins(.regular, size: 16))
            .padding(.top, 15)
            Spacer()
            VStack(alignment: .leading, spacing: 17) {
                Text(L10n.termsOfService)
                    .font(.poppins(.medium, size: 16))
                Text(L10n.pp)
                    .font(.poppins(.medium, size: 16))
            }
            .font(.poppins(.regular, size: 14))
            .padding(.bottom, 10)
            Button {
                viewModel.logOutUser()
            } label: {
                Text(L10n.logout)
                    .font(.poppins(.bold, size: 16))
                    .foregroundColor(Color.black)
                    .padding(.top)
            }
            .padding(.bottom, 30)

        }
        .padding(.leading, 32)
    }
}
