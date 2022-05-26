//
//  EstablishConnectionView.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import SwiftUI

struct EstablishConnectionView: View {
    var body: some View {
        VStack {
            header
            container
                .padding(.top, 30)
            Spacer()
            footer
        }
        .background(Color.grayBackgroundColor)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
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
        VStack( spacing: 32) {
            Image.bluetoothIcon
            Text(L10n.enableBluetooth)
            verticalDots
            deviceCell
            Text(L10n.someText)
            verticalDots
            Image.loadIcon
            Text(L10n.lookingForDevice)
        }.padding(.leading)
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
    var verticalDots: some View {
        VStack(spacing: 12) {
            Image.dotIcon
            Image.dotIcon
            Image.dotIcon
            Image.dotIcon
            Image.dotIcon
        }
    }
    var deviceCell: some View {
        NavigationLink {
            EstablishConnectionView()
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.white)
                .frame(height: 100)
                .padding(.trailing)
                .overlay(overlay)
        }
    }
    var overlay: some View {
        HStack {
            Image.dexicomDeviceIcon
                .resizable()
                .frame(width: 85, height: 73)
        }
    }
}

struct EstablishConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        EstablishConnectionView()
    }
}
