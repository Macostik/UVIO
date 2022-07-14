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
    @State var isEditUserName = false
    @State var isEditEmail = false
    @State var isEditDiabetType = false
    @State var showFooter = false
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundView
            VStack {
                navigationBarView
                contentView
                    .padding(.horizontal)
                Spacer()
                if showFooter {
                    footerView
                        .transition(.move(edge: .bottom))
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            genderMenuView
            dobMenuView
            changePasswordView
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .passwordToast(type: $viewModel.passwordMode)
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
            .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
    }
    var navigationBarView: some View {
        NavigationBackBarViewAction(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            ZStack {
                Text(L10n.accountInformation)
                    .font(.poppins(.medium, size: 18))
            }
        }, backgroundColor: Color.white)
    }
    var contentView: some View {
        VStack {
            topView
            fullNameView
            emailView
            genderView
            dobView
            bloodGlucoseView
            unitsView
        }
    }
    var topView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(L10n.personal)
                    .font(.poppins(.bold, size: 18))
                Spacer()
                Button {
                    withAnimation {
                        viewModel.isChangePassword.toggle()
                    }
                } label: {
                    Text(L10n.changePassword)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.complementaryColor)
                }
            }
            .padding(.top)
        }
    }
    var fullNameView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(fullNameOverlay, alignment: .leading)
                .frame(height: 48)
        }
    }
    var fullNameOverlay: some View {
        ZStack(alignment: .leading) {
            Text(L10n.fullName)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            ZStack(alignment: .leading) {
                Text(viewModel.user?.name ?? "")
                    .foregroundColor(self.isEditUserName ? Color.clear : Color.black)
                TextField("", text: $viewModel.name)
                    .onChange(of: viewModel.name, perform: { _ in
                        self.isEditUserName = true
                    })
                    .font(.poppins(.bold, size: 14))
                    .accentColor(Color.black)
            }
            .font(.poppins(.bold, size: 14))
            .offset(x: 100)
            .padding(.trailing, 100)
        }
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
        ZStack(alignment: .leading) {
            Text(L10n.email)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            ZStack(alignment: .leading) {
                Text(viewModel.user?.email ?? "")
                    .foregroundColor(self.isEditEmail ? Color.clear : Color.black)
                TextField("", text: $viewModel.email)
                    .onChange(of: viewModel.email, perform: { _ in
                        self.isEditEmail = true
                    })
                    .font(.poppins(.bold, size: 14))
                    .accentColor(Color.black)
            }
            .font(.poppins(.bold, size: 14))
            .offset(x: 100)
            .padding(.trailing, 100)
        }
    }
    var genderView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(genderOverlay, alignment: .leading)
                .frame(height: 48)
                .onTapGesture {
                    withAnimation {
                        viewModel.isGenderPresented.toggle()
                    }
                }
        }
    }
    var genderOverlay: some View {
        HStack {
            Text(L10n.gender)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            Text(viewModel.user?.gender ?? "")
                .font(.poppins(.bold, size: 14))
                .foregroundColor(Color.black)
                .accentColor(Color.black)
                .offset(x: 9)
            Spacer()
            Image.arrowBottomIcon
                .rotationEffect(.radians(.pi))
        }
        .padding(.trailing)
    }
    var dobView: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .frame(height: 48)
                .overlay(dobOverlay, alignment: .leading)
                .onTapGesture {
                    withAnimation {
                        viewModel.isDOBPresented.toggle()
                    }
                }
        }
    }
    var dobOverlay: some View {
        ZStack(alignment: .leading) {
            Text(L10n.dob)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            Text(viewModel.birthDateString)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .offset(x: 100)
        }
    }
    var bloodGlucoseView: some View {
        VStack(alignment: .leading) {
            Text(L10n.bloodGlucoseUnit)
                .font(.poppins(.bold, size: 18))
            HStack {
                ScrollView([]) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.glucoseTypeList,
                                id: \.id) { item in
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(item.isSelected ? Color.clear : Color.white)
                                .frame(height: 48)
                                .overlay(genderOverlay(type: item.type,
                                                       isSelected: item.isSelected))
                                .foregroundColor(Color.black)
                                .overlay(RoundedRectangle(cornerRadius: 12.0)
                                    .stroke(lineWidth: item.isSelected ? 2.0 : 0.0)
                                    .foregroundColor(Color.white))
                                .onTapGesture {
                                    withAnimation {
                                        if !showFooter {
                                            showFooter = !item.isSelected
                                        }
                                    }
                                    viewModel.glucoseTypeSelectedItem = item
                                }
                        }
                    }
                }
            }
            .frame(height: 48)
        }
        .padding(.top)
    }
    var unitsView: some View {
        VStack(alignment: .leading) {
            Text(L10n.units)
                .font(.poppins(.bold, size: 18))
            HStack {
                ScrollView([]) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(unitsList,
                                id: \.id) { item in
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(item.isSelected ? Color.clear : Color.white)
                                .frame(height: 48)
                                .overlay(genderOverlay(type: item.type,
                                                       isSelected: item.isSelected))
                                .foregroundColor(Color.black)
                                .overlay(RoundedRectangle(cornerRadius: 12.0)
                                    .stroke(lineWidth: item.isSelected ? 2.0 : 0.0)
                                    .foregroundColor(Color.white))
                                .onTapGesture {
                                    self.viewModel.unitsSelectedItem = item
                                }
                        }
                    }
                }
            }
            .frame(height: 48)
        }
    }
    var footerView: some View {
        ZStack {
            Button {
                viewModel.saveData.send()
                withAnimation {
                    showFooter = false
                }
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
    @ViewBuilder
    func genderOverlay(type: String,
                       isSelected: Bool) -> some View {
        HStack {
            Circle()
                .foregroundColor(Color.grayScaleColor)
                .frame(width: 24, height: 24)
                .padding(.leading)
                .overlay(isSelected ? selectedOverlay : nil)
            Text(type)
                .font(.poppins(.medium, size: 14))
            Spacer()
        }
    }
    var selectedOverlay: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.white)
                .frame(width: 24, height: 24)
                .cornerRadius(12)
                .padding(.leading, 16)
            Circle()
                .foregroundColor(Color.complementaryColor)
                .frame(width: 12, height: 12).cornerRadius(6)
                .padding(.leading, 16)
        }
    }
    var genderMenuView: some View {
        GenderView(viewModel: viewModel)
    }
    var dobMenuView: some View {
        DOBView(viewModel: viewModel)
    }
    var changePasswordView: some View {
        ChangePasswordView(viewModel: viewModel)
    }
}
