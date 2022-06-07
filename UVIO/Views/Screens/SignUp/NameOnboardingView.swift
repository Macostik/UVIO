//
//  NameOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI
import Combine

struct NameOnboardingView: View, Identifiable {
    let id = UUID()
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                contentView
                Spacer()
                VStack(spacing: 26) {
                    NextButtonAction {
                        viewModel.presentOnboardingView.value = .birthDate
                    }
                    SkipButton(destination: CompleteOnboardingView(viewModel: viewModel))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NameOnboardingView(viewModel: UserViewModel())
    }
}

extension NameOnboardingView {
    var contentView: some View {
        VStack(spacing: 32) {
            Text(L10n.whatName)
                .font(.poppins(.bold, size: 24))
            TextField(L10n.eg, text: $viewModel.name)
                .padding(.leading)
                .font(.poppins(.medium, size: 14))
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.1),
                        radius: 7)
        }
    }
}
