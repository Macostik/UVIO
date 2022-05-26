//
//  WelcomeView.swift
//  UVIO
//
//  Created by Macostik on 26.05.2022.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image.loginViewBackground
                .resizable()
            Text(L10n.welcome)
                .font(.poppins(.medium, size: 32))
                .foregroundColor(Color.complementaryColor)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
