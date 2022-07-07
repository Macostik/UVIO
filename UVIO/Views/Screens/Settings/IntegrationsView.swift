//
//  IntegrationsView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct IntegrationsView: View {
    @StateObject var viewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            VStack {
                navigationBarView
                contentView
            }
        }
        .navigationBarHidden(true)
    }
}

struct IntegrationsView_Previews: PreviewProvider {
    static var previews: some View {
        IntegrationsView(viewModel: UserViewModel())
    }
}

extension IntegrationsView {
    var backgroundView: some View {
        Rectangle()
            .foregroundColor(Color.grayScaleColor)
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
    var navigationBarView: some View {
        NavigationBackBarViewAction(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            ZStack {
                Text(L10n.integrations)
                    .font(.poppins(.medium, size: 18))
            }
        }, backgroundColor: Color.white)
    }
    var contentView: some View {
        VStack(alignment: .leading) {
            Text(L10n.selecteDevices)
                .font(.poppins(.bold, size: 18))
                .padding(.top)
            Text(L10n.dexcom)
                .font(.poppins(.bold, size: 12))
                .padding(.top, 2)
            deviceView
            addButton
        }
        .padding(.leading)
    }
    var deviceView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .frame(height: 68)
                .overlay(deviceOverlay)
        }
        .padding(.trailing)
    }
    var deviceOverlay: some View {
        ZStack {
            HStack {
                Image.dexicomDeviceIcon
                    .resizable()
                    .frame(width: 44, height: 38)
                VStack {
                    Text(L10n.dexcomG6)
                        .font(.poppins(.bold, size: 14))
                    Text(L10n.connected)
                        .font(.poppins(.bold, size: 14))
                        .foregroundColor(Color.greenSuccessColor)
                }
                Spacer()
                Image.vDotsIcon
                    .colorInvert()
            }
            .padding(.horizontal)
        }
    }
    var addButton: some View {
        Button {
        } label: {
            Image.plusIcon
                .foregroundColor(Color.white)
                .frame(width: 40, height: 40)
                .background(Color.complementaryColor)
                .cornerRadius(12)
        }
        .padding(.top, 16)
    }
}
