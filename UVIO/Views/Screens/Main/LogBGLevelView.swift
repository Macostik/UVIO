//
//  LogBGLevelView.swift
//  UVIO
//
//  Created by Macostik on 17.06.2022.
//

import SwiftUI

struct LogBGLevelView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isCalendarOpen = false
    @State var isTimePickerOpen = false
    @State var isNodeAdded = false
    @State var offset = 0.0
    var body: some View {
                ZStack {
                    VStack {
                        if viewModel.isLogBGPresented {
                            contentView
                                .transition(.move(edge: .bottom))
                            }
                        }
                    }
                .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
        }
}

struct LogBGLevelView_Previews: PreviewProvider {
    static var previews: some View {
        LogBGLevelView(viewModel: MainViewModel())
    }
}

extension LogBGLevelView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Image.bgLevelIcon
                Text(L10n.createEntry)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top)
                inputContainer
                whenContainer
                timeContainer
                addNote
                submitLogButton
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
                    if yOffset > 0 && !isCalendarOpen && !isTimePickerOpen {
                        offset = yOffset
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        self.viewModel.isLogBGPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var inputContainer: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(inputOverlay)
                .frame(height: 204)
                .padding(.horizontal)
        }
    }
    var inputOverlay: some View {
        VStack(spacing: 12) {
            TextField("0.0", text: $viewModel.logBGInput)
                .font(.poppins(.bold, size: 80))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .foregroundColor(Color.capsulaGrayColor)
                .accentColor(Color.black)
            Text(L10n.mmolL)
                .font(.poppins(.medium, size: 18))
            Text(L10n.glucose)
                .font(.poppins(.bold, size: 18))
        }
    }
    var whenContainer: some View {
        VStack {
            if isTimePickerOpen {
                DatePicker("", selection: $viewModel.logBGTimeValue, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .animation(.easeInOut)
            } else {
                Button {
                    isTimePickerOpen = false
                    isCalendarOpen.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .overlay(whenOverlay, alignment: .leading)
                        .frame(height: 48)
                        .padding(.horizontal)
                }
            }
        }
    }
    var whenOverlay: some View {
        HStack {
            Text(L10n.when)
                .font(.poppins(.medium, size: 14))
            Text(viewModel.selectedLogBGDate)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var timeContainer: some View {
        VStack {
            if isCalendarOpen {
                VStack(alignment: .trailing) {
                    DatePicker("", selection: $viewModel.logBGWhenValue, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .animation(.easeInOut)
            } else {
                Button {
                    isTimePickerOpen.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .overlay(timeOverlay, alignment: .leading)
                        .frame(height: 48)
                        .padding(.horizontal)
                }
            }
        }
    }
    var timeOverlay: some View {
        HStack {
            Text(L10n.time)
                .font(.poppins(.medium, size: 14))
            Text(viewModel.selectedLogBGTime)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var addNote: some View {
        VStack {
            if isNodeAdded {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(inputNoteOverlay, alignment: .leading)
                    .frame(height: 48)
                    .padding(.horizontal)
            } else {
                Button {
                    isNodeAdded = true
                } label: {
                    Text(L10n.addNote)
                        .font(.poppins(.medium, size: 14))
                        .foregroundColor(Color.complementaryColor)
                        .padding(.top)
                }
            }
        }
    }
    var noteOverlay: some View {
        VStack {
            if isNodeAdded {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
                    .overlay(inputNoteOverlay, alignment: .leading)
                    .frame(height: 48)
                    .padding(.horizontal)
            } else {
                Text(L10n.addNote)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.complementaryColor)
                    .padding(.top)
            }
        }
    }
    var inputNoteOverlay: some View {
        HStack {
            Text(L10n.myNote)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.logBGNote)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
    var submitLogButton: some View {
        Button {
            viewModel.subminLogBGPublisher.send()
        } label: {
            ZStack {
                HStack {
                    Image.checkMarkIcon
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
            .background(Color.complementaryColor)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(
                Text(L10n.submitBGLog)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.white)
            )
        }
        .padding(.top, 17)
    }
    var cancelButton: some View {
        Button {
            withAnimation {
                viewModel.isLogBGPresented = false
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
