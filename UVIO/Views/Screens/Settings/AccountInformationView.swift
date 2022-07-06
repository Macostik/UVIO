//
//  AccountInformationView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct AccountInformationView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            navigationBarView
            VStack {
                contentView
                Spacer()
                footerView
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

struct AccountInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInformationView(viewModel: UserViewModel())
    }
}

extension AccountInformationView {
    var backgroundView: some View {
        Rectangle()
            .foregroundColor(Color.grayScaleColor)
            .ignoresSafeArea()
    }
    var navigationBarView: some View {
        NavigationBackBarViewAction(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            ZStack {
                Text(L10n.bgLevelAlerts)
                    .font(.poppins(.medium, size: 18))
            }
        }, backgroundColor: Color.white)
    }
    var contentView: some View {
        VStack {
            topView
            foodNameView
            emailView
            genderView
            dobView
            diabetTypeView
            bloodGlucoseView
        }
    }
    var topView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(L10n.personal)
                    .font(.poppins(.bold, size: 18))
                Spacer()
                NavigationLink {
                } label: {
                    Text(L10n.changePassword)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.blue)
                }
            }
            .padding(.top)
        }
    }
    var foodNameView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(foodOverlay, alignment: .leading)
                .frame(height: 48)
        }
    }
    var foodOverlay: some View {
        HStack {
            Text(L10n.fullName)
                .font(.poppins(.medium, size: 14))
            TextField("Frank Woodgate", text: $viewModel.name)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var emailView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(emailOverlay, alignment: .leading)
                .frame(height: 48)
        }
    }
    var emailOverlay: some View {
        HStack {
            Text(L10n.email)
                .font(.poppins(.medium, size: 14))
            TextField("email@gmail.com", text: $viewModel.email)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var genderView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(genderOverlay, alignment: .leading)
                .frame(height: 48)
        }
    }
    var genderOverlay: some View {
        HStack {
            Text(L10n.gender)
                .font(.poppins(.medium, size: 14))
            TextField("Male", text: $viewModel.name)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var dobView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(dobOverlay, alignment: .leading)
                .frame(height: 48)
        }
    }
    var dobOverlay: some View {
        HStack {
            Text(L10n.dob)
                .font(.poppins(.medium, size: 14))
            TextField("10/05/1987", text: $viewModel.name)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var diabetTypeView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(diabetTypeOverlay, alignment: .leading)
                .frame(height: 48)
        }
    }
    var diabetTypeOverlay: some View {
        HStack {
            Text(L10n.gender)
                .font(.poppins(.medium, size: 14))
            TextField("Type 1", text: $viewModel.name)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var bloodGlucoseView: some View {
        HStack {
            Text(L10n.bloodGlucoseUnit)
                .font(.poppins(.bold, size: 18))
            Spacer()
        }
    }
    var footerView: some View {
        ZStack {
            Button {
            } label: {
                HStack {
                    Image.checkMarkIcon
                    Text(L10n.save)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.complementaryColor)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .frame(height: 100)
            .background(Color.white)
        }
    }
}
