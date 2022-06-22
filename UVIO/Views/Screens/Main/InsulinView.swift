//
//  InsulinView.swift
//  UVIO
//
//  Created by Macostik on 21.06.2022.
//

import SwiftUI

struct InsulinView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isCalendarOpen = false
    @State var isTimePickerOpen = false
    @State var isNodeAdded = false
    @State var offset = 0.0
    @Namespace var aniamtion
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isInsulinPresented {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct InsulinView_Previews: PreviewProvider {
    static var previews: some View {
        InsulinView(viewModel: MainViewModel())
    }
}

extension InsulinView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                if viewModel.selectedSegementItem == L10n.rapidAction {
                    Image.rapidInsulinIcon
                } else {
                    Image.longInsulinIcon
                }
                Text(L10n.logInsulin)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top)
                segmentControlView
                CounterView(counter: $viewModel.insulinCounter,
                            unit: $viewModel.subtitle,
                            color: $viewModel.insulinMainColor)
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
                        self.viewModel.isInsulinPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
    }
    var segmentControlView: some View {
        HStack {
            ForEach(viewModel.segementItems, id: \.self) { title in
                SegmentControl(selectedTab: $viewModel.selectedSegementItem,
                               title: title,
                               animation: aniamtion)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 5)
        .background(Color.capsulaGrayColor)
        .cornerRadius(16)
        .padding(.horizontal)
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
    var inputNoteOverlay: some View {
        HStack {
            Text(L10n.myNote)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.insulineNote)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
    var submitLogButton: some View {
        Button {
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
                Text(L10n.submitInsulin)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.white)
            )
        }
        .padding(.top, 17)
    }
    var cancelButton: some View {
        Button {
            withAnimation {
                viewModel.isInsulinPresented = false
            }
        } label: {
            Text(L10n.cancel)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .frame(height: 48)
                .padding(.horizontal)
        }
    }
    var whenContainer: some View {
        VStack {
            if isTimePickerOpen {
                DatePicker("", selection: $viewModel.insulinTimeValue, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .animation(.easeInOut)
            } else {
                VStack {
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
    }
    var whenOverlay: some View {
        HStack {
            Text(L10n.when)
                .font(.poppins(.medium, size: 14))
            Text(viewModel.selectedInsulinDate)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
    var timeContainer: some View {
        VStack {
            if isCalendarOpen {
                VStack(alignment: .trailing) {
                    DatePicker("", selection: $viewModel.insulinWhenValue, displayedComponents: [.date])
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
            Text(viewModel.selectedInsulinTime)
                .font(.poppins(.bold, size: 14))
        }
        .foregroundColor(Color.black)
        .padding()
    }
}
