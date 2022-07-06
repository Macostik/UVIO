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
    @State var isEditBirthDate = false
    @State var isEditDiabetType = false
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            VStack {
                navigationBarView
                contentView
                    .padding(.horizontal)
                Spacer()
                footerView
            }
            .edgesIgnoringSafeArea(.bottom)
        }
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
            fullNameView
            emailView
            genderView
            dobView
            diabetTypeView
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
                NavigationLink {
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
        }
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
        ZStack(alignment: .leading) {
            Text(L10n.gender)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            Text(viewModel.user?.gender ?? "")
                .font(.poppins(.bold, size: 14))
                .foregroundColor(Color.black)
                .accentColor(Color.black)
                .offset(x: 100)
        }
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
        ZStack(alignment: .leading) {
            Text(L10n.dob)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            Text(viewModel.birthDateString)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .offset(x: 100)
                .onTapGesture {
                    self.isEditBirthDate.toggle()
                }
        }
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
        ZStack(alignment: .leading) {
            Text(L10n.gender)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding()
            Text(viewModel.user?.diabetsType ?? "")
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .offset(x: 100)
                .onTapGesture {
                    self.isEditDiabetType.toggle()
                }
        }
    }
    var bloodGlucoseView: some View {
        VStack(alignment: .leading) {
            Text(L10n.bloodGlucoseUnit)
                .font(.poppins(.bold, size: 18))
            HStack {
                ScrollView([]) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(glucoseTypeList,
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
                                    self.viewModel.glucoseSelectedItem = item
                                }
                        }
                    }
                }
            }
            .frame(height: 48)
            Spacer()
        }
        .padding(.top, 72)
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
}
