//
//  BirthDateOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI

struct BirthDateOnboardingView: View, Identifiable {
    let id = UUID()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: UserViewModel
    @State private var isPresentedDatePicker = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                contentView
                Spacer()
                VStack(spacing: 26) {
                    NextButtonAction {
                        viewModel.presentOnboardingView.value = .gender
                    }
                    SkipButton(destination: CompleteOnboardingView(viewModel: viewModel,
                                                                   mainViewModel: MainViewModel()))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoginBirthdateView_Previews: PreviewProvider {
    static var previews: some View {
        BirthDateOnboardingView(viewModel: UserViewModel())
    }
}

extension BirthDateOnboardingView {
    var contentView: some View {
        VStack {
            Text(L10n.whatIsYourBD)
                .font(.poppins(.bold, size: 24))
            DatePickerView(date: $viewModel.birthDate,
                           isPresentedDatePicker: $isPresentedDatePicker)
            .padding(.top)
        }
    }
}
