//
//  LogBGLevelView.swift
//  UVIO
//
//  Created by Macostik on 17.06.2022.
//

import SwiftUI

struct LogBGLevelView: View {
    @StateObject var keyboard = KeyboardHandler()
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
        .animation(.easeInOut)
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""
        return formatter
    }()
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
                    .padding(.top, 10)
                Image.bgLevelIcon
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.top, 10)
                Text(L10n.logManualyBGLevel)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top, -8)
                inputContainer
                whenContainer
                timeContainer
                addNote
                footerView
            }
            .background(Color.graySettingsColor)
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
                .frame(height: 220)
                .padding(.horizontal)
        }
    }
    var inputOverlay: some View {
        VStack {
            TextFieldDone(text: $viewModel.logBGInput, keyType: .numberPad)
                .onTapGesture {
                    withAnimation {
                        isNodeAdded = false
                        isTimePickerOpen = false
                        isCalendarOpen = false
                    }
                }
            Text(viewModel.user?.glucoseUnit ?? "")
                .font(.poppins(.medium, size: 18))
                .offset(y: -50)
            Text(L10n.glucose)
                .font(.poppins(.bold, size: 18))
                .offset(y: -40)
        }
    }
    var whenContainer: some View {
        VStack {
            if isTimePickerOpen {
                DatePicker("",
                           selection: $viewModel.logBGTimeValue,
                           displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .animation(.easeInOut)
            } else {
                Button {
                    isCalendarOpen.toggle()
                    withAnimation {
                        hideKeyboard()
                        isNodeAdded = false
                        isTimePickerOpen = false
                    }
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
                    DatePicker("", selection:
                                $viewModel.logBGWhenValue,
                               displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .animation(.easeInOut)
            } else {
                Button {
                    isTimePickerOpen.toggle()
                    withAnimation {
                        hideKeyboard()
                        isNodeAdded = false
                        isCalendarOpen = false
                    }
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
                        .padding(.vertical)
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
                .onTapGesture {
                    withAnimation {
                        isCalendarOpen = false
                        isTimePickerOpen = false
                    }
                }
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
    var footerView: some View {
        VStack {
            submitLogButton
            cancelButton
                .padding(.top, 8)
                .padding(.bottom, keyboard.isShown ? 170 : 26)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
    var submitLogButton: some View {
        Button {
            viewModel.subminLogBGPublisher.send()
            withAnimation {
                viewModel.isLogBGPresented = false
            }
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
        .padding(.top, 16)
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
