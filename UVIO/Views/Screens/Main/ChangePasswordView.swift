//
//  ChangePasswordView.swift
//  UVIO
//
//  Created by Macostik on 08.07.2022.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel: UserViewModel
    @State var offset: CGFloat = 0.0
    @State var isEditOldPassword = false
    @State var isEditNewPassword = false
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isChangePassword {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(viewModel: UserViewModel())
    }
}

extension ChangePasswordView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Text(L10n.changePassword)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top)
                oldPasswordView
                newPasswordView
                saveButton
                cancelButton
                    .padding(.bottom, 40)
            }
            .background(Color.bottomBGColor)
            .clipShape(RoundedCorner(radius: 24,
                                     corners: [.topLeft, .topRight]))
            .offset(y: self.offset)
            .gesture(DragGesture()
                .onChanged { gesture in
                    let yOffset = gesture.location.y
                    if yOffset > 0 {
                        offset = yOffset
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        self.viewModel.isChangePassword = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var oldPasswordView: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color.white)
            .overlay(oldPasswordViewOverlay, alignment: .leading)
            .frame(height: 48)
            .padding(.horizontal)
            .padding(.bottom, 15)
    }
    var oldPasswordViewOverlay: some View {
        HStack {
            Text(L10n.oldPassword)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding(.leading)
            Group {
                if isEditOldPassword {
                    TextField("", text: $viewModel.oldPassword)
                } else {
                    SecureField("", text: $viewModel.oldPassword)
                }
            }
            .font(.poppins(.bold, size: 14))
            .accentColor(Color.black)
            .offset(x: 6)
            .padding(.trailing, 6)
            .overlay(hideOldOverlay, alignment: .trailing)
        }
    }
    var newPasswordView: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color.white)
            .overlay(newPasswordViewOverlay, alignment: .leading)
            .frame(height: 48)
            .padding(.horizontal)
            .padding(.bottom, 15)
    }
    var newPasswordViewOverlay: some View {
        HStack {
            Text(L10n.newPassword)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .padding(.leading)
            Group {
                if isEditOldPassword {
                    TextField("", text: $viewModel.newPassword)
                } else {
                    SecureField("", text: $viewModel.newPassword)
                }
            }
            .font(.poppins(.bold, size: 14))
            .accentColor(Color.black)
            .padding(.trailing)
            .overlay(hideNewOverlay, alignment: .trailing)
        }
    }
    var hideNewOverlay: some View {
        VStack {
            if isEditNewPassword {
                Image.eyeIcon
            } else {
                Image.hideIcon
            }
        }.padding(.trailing)
            .onTapGesture {
                $isEditNewPassword.wrappedValue.toggle()
            }
    }
    var hideOldOverlay: some View {
        VStack {
            if isEditOldPassword {
                Image.eyeIcon
            } else {
                Image.hideIcon
            }
        }.padding(.trailing)
            .onTapGesture {
                $isEditOldPassword.wrappedValue.toggle()
            }
    }
    var saveButton: some View {
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
    }

    var cancelButton: some View {
        Button {
            withAnimation {
                self.viewModel.isChangePassword = false
            }
        } label: {
            Text(L10n.cancel)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .frame(height: 48)
                .padding(.horizontal)
        }
    }
}
