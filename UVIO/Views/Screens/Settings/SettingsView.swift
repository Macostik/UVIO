//
//  SettingsView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .topLeading) {
            backgroundView
            navigationBarView
            contentView
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
            Spacer()
            VStack(alignment: .leading, spacing: 40) {
                Text(L10n.menu)
                    .font(.poppins(.bold, size: 24))
                Button {
                } label: {
                    HStack(spacing: 15) {
                        Image.summaryIcon
                        Text(L10n.mySummary)
                    }
                }
                Button {
                } label: {
                    HStack(spacing: 15) {
                        Image.menuIcon
                        Text(L10n.mySummary)
                    }
                }
                Button {
                } label: {
                    HStack(spacing: 15)  {
                        Image.bgAlertIcon
                        Text(L10n.mySummary)
                    }
                }
                Button {
                } label: {
                    HStack(spacing: 15) {
                        Image.devicesIcon
                        Text(L10n.devices)
                    }
                }
                Button {
                } label: {
                    HStack(spacing: 15)  {
                        Image.reportIcon
                        Text(L10n.reportIssue)
                    }
                }
            }
            .foregroundColor(Color.black)
            .font(.poppins(.regular, size: 16))
            Spacer()
            VStack(alignment: .leading, spacing: 15) {
                Text(L10n.termsOfService)
                Text(L10n.privacyPolicy)
            }
            .font(.poppins(.regular, size: 14))
            Button {
                _ = viewModel.logOut()
            } label: {
                Text(L10n.logout)
                    .font(.poppins(.bold, size: 14))
                    .foregroundColor(Color.black)
                    .padding(.top)
            }
            Spacer()
        }
        .padding(.leading, 30)
    }
}
