//
//  SelectDeviceView.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import SwiftUI

struct SelectDeviceView: View {
    var body: some View {
        VStack {
            header
            container
            Spacer()
            footer
        }
        .background(Color.grayBackgroundColor)
        .edgesIgnoringSafeArea(.bottom)
    }
    var header: some View {
        VStack {
            NativigationBackBarView {
                Text(L10n.connectCGM)
                    .font(.poppins(.medium, size: 18))
            }.background(Color.white)
        }
    }
    var container: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.selecteDevices)
                .font(.poppins(.bold, size: 18))
            Text(L10n.dexcom)
                .font(.poppins(.bold, size: 12))
            topDeviceCell
            Text(L10n.freestyleLibre)
                .font(.poppins(.bold, size: 12))
            bottomDeviceCell
        }.padding(.leading)
    }
    var topDeviceCell: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.white)
            .frame(height: 68)
            .padding(.trailing)
            .overlay(topOverlay)
    }
    var topOverlay: some View {
        HStack {
            Image.dexicomDeviceIcon
                .resizable()
                .frame(width: 44, height: 38)
            Text(L10n.dexcomG6)
                .font(.poppins(.bold, size: 16))
            Spacer()
            Image.chevronIcon
                .padding(.trailing)
        }
        .padding()
    }
    var bottomDeviceCell: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.white)
            .frame(height: 68)
            .padding(.trailing)
            .overlay(bottomOverlay)
    }
    var bottomOverlay: some View {
        HStack {
            Image.freestyleDeviceIcon
                .resizable()
                .frame(width: 32, height: 48)
            Text(L10n.freestyleLibre2)
                .font(.poppins(.bold, size: 16))
            Spacer()
            Image.chevronIcon
                .padding(.trailing)
        }
        .padding()
    }
    var footer: some View {
        HStack {
            NavigationLink(destination: EmptyView()) {
                Text(L10n.cancel)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.black)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: 84)
            .background(Color.white)
        }
    }
}

struct SelectDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDeviceView()
    }
}
