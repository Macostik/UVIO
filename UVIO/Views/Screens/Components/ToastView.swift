//
//  ToastView.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import SwiftUI

struct ToastView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(L10n.dot)
                Text(L10n.emailIsRequired)
            }
            HStack {
                Text(L10n.dot)
                Text(L10n.passwordIsRequired)
            }
        }
        .foregroundColor(Color.white)
        .font(.poppins(.medium, size: 14))
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryAlertColor)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

//extension View: ViewModifier {
//    @Binding var showToast: Bool
//
//    func body(content: Content) -> some View {
//        return content
//            .transition(.move(edge: .top))
//            .animation(Animation.easeInOut)
//            .zIndex(1)
//    }
//}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView()
    }
}
