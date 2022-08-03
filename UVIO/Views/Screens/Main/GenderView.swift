//
//  GenderView.swift
//  UVIO
//
//  Created by Macostik on 07.07.2022.
//

import SwiftUI

struct GenderView: View {
    @StateObject var keyboard = KeyboardHandler()
    @StateObject var viewModel: UserViewModel
    @State var offset: CGFloat = 0.0
    @State var isShowInputView = false
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isGenderPresented {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        GenderView(viewModel: UserViewModel())
    }
}

extension GenderView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Text(L10n.gender)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top)
                buttonsContainerView
                if isShowInputView {
                    inputView
                }
                saveButton
                cancelButton
                    .padding(.bottom, keyboard.isShown ? 90 : 26)
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
                        self.viewModel.isGenderPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var buttonsContainerView: some View {
        ScrollView([]) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(genderTypeList,
                        id: \.id) { item in
                    Button {
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(item.isSelected ?
                                             Color.complementaryColor :
                                                Color.white)
                            .frame(height: 79)
                            .overlay(
                                VStack {
                                    Text(item.type)
                                        .foregroundColor(item.isSelected ?
                                                         Color.white :
                                                            Color.black)
                                        .font(.poppins(.medium, size: 14))
                                }
                            )
                            .onTapGesture {
                                withAnimation {
                                    self.isShowInputView = item.type == L10n.other
                                }
                                self.viewModel.genderSelectedItem = item
                            }
                    }
                }
            }
            .padding()
        }
        .frame(height: 200)
    }
    var saveButton: some View {
        Button {
            self.viewModel.updateUserDataPublisher.send(())
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
                self.viewModel.isGenderPresented = false
            }
        } label: {
            Text(L10n.cancel)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .frame(height: 48)
                .padding(.horizontal)
        }
    }
    var inputView: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color.white)
            .overlay(inputViewOverlay, alignment: .leading)
            .frame(height: 48)
            .padding(.horizontal)
            .padding(.bottom, 15)
    }
    var inputViewOverlay: some View {
        HStack {
            Text(L10n.myNote)
                .font(.poppins(.medium, size: 14))
            TextField(L10n.provideOwn, text: $viewModel.ownType)
                .font(.poppins(.medium, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
}
