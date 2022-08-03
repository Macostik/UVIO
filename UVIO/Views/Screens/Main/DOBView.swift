//
//  DOBView.swift
//  UVIO
//
//  Created by Macostik on 08.07.2022.
//

import SwiftUI

struct DOBView: View {
    @StateObject var viewModel: UserViewModel
    @State var offset: CGFloat = 0.0
    @State var isShowCalendar = false
    var previousDOBValue = ""
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isDOBPresented {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct DOBView_Previews: PreviewProvider {
    static var previews: some View {
        DOBView(viewModel: UserViewModel())
    }
}

extension DOBView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Text(L10n.dateOfBirth)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top)
                dobView
                if isShowCalendar {
                    VStack(alignment: .trailing) {
                        DatePicker("", selection:
                                    $viewModel.birthDate,
                                   displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
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
                    if yOffset > 0 && !isShowCalendar {
                        offset = yOffset
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        self.viewModel.isDOBPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var dobView: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color.white)
            .overlay(dobViewOverlay, alignment: .leading)
            .frame(height: 48)
            .padding(.horizontal)
            .padding(.bottom, 15)
            .onTapGesture {
                withAnimation {
                    self.isShowCalendar.toggle()
                }
            }
    }
    var dobViewOverlay: some View {
        HStack {
            Text(viewModel.birthDate.convertToString())
                .font(.poppins(.medium, size: 14))
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
    var saveButton: some View {
        Button {
            viewModel.updateUserDataPublisher.send(())
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
                self.viewModel.isDOBPresented = false
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
