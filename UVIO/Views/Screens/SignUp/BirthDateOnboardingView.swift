//
//  BirthDateOnboardingView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import SwiftUI

struct BirthDateOnboardingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var loginViewModel: BirthDateOnboardingViewModel
    @State private var birthDateValue = Date()
    @State private var isPresentedDatePicker = false
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    init(viewModel: BirthDateOnboardingViewModel) {
        self.loginViewModel  = viewModel
    }
    var body: some View {
        ZStack {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .bottom) {
                VStack(spacing: 16) {
                    Spacer()
                    contentView
                    Spacer()
                    NextButton(destination: GenderOnboardingView(viewModel: GenderOnboardingViewModel()))
                        .opacity(isPresentedDatePicker ? 0.0 : 1.0)
                    SkipButton()
                        .padding(.bottom, 30)
                }
                if isPresentedDatePicker {
                    DatePickerView(date: $birthDateValue,
                                   isPresentedDatePicker: $isPresentedDatePicker)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                ProgressView(completed: 0.4)
            }
        })
    }
    var contentView: some View {
        VStack {
            Text(L10n.whatIsYourBD)
                .font(.poppins(.bold, size: 24))
            Button(action: {
                withAnimation {
                    isPresentedDatePicker = true
                }
            }, label: {
                Text(dateFormatter.string(from: birthDateValue))
                    .padding()
                    .font(.poppins(.medium, size: 14))
                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .leading)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .padding()
            })
        }
    }
}

struct LoginBirthdateView_Previews: PreviewProvider {
    static var previews: some View {
        BirthDateOnboardingView(viewModel: BirthDateOnboardingViewModel())
    }
}
