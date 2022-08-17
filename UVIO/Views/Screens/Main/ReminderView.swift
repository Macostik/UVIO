//
//  ReminderView.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import SwiftUI

struct ReminderView: View {
    @StateObject var keyboard = KeyboardHandler()
    @EnvironmentObject var viewModel: MainViewModel
    @State var isCalendarOpen = false
    @State var isTimePickerOpen = false
    @State var isNodeAdded = false
    @State var offset = 0.0
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isReminderPresented {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.easeInOut)
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct RemainderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView()
    }
}

extension ReminderView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top, 8)
                Image.remainderIcon
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.top, 5)
                    .offset(y: 5)
                Text(L10n.setReminder)
                    .font(.poppins(.medium, size: 18))
                    .padding(.bottom, -5)
                CounterView(counter: $viewModel.reminderCounter,
                            unit: $viewModel.reminderSubtitle,
                            color: .constant(Color.segmentBGColor.opacity(0.8)),
                            buttonColor: $viewModel.reminderColor,
                            isInvertedColor: true)
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
                        self.viewModel.isReminderPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var footerView: some View {
        VStack {
            submitLogButton
            cancelButton
                .padding(.top, 8)
                .padding(.bottom, keyboard.isShown ? 200 : 26)
        }
        .background(Color.white)
    }
    var submitLogButton: some View {
        Button {
            viewModel.subminReminderPublisher.send()
            withAnimation {
                viewModel.isReminderPresented = false
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
                Text(L10n.addReminder)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.white)
            )
        }
        .padding(.top, 16)
    }
    var cancelButton: some View {
        Button {
            withAnimation {
                viewModel.isReminderPresented = false
            }
        } label: {
            Text(L10n.cancel)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .frame(height: 48)
                .padding(.horizontal)
        }
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
                        .padding(.bottom)
                }
            }
        }
    }
    var inputNoteOverlay: some View {
        HStack {
            Text(L10n.myNote)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.reminderNote)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
}
