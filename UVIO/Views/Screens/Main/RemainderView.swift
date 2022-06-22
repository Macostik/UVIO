//
//  RemainderView.swift
//  UVIO
//
//  Created by Macostik on 22.06.2022.
//

import SwiftUI

struct RemainderView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isCalendarOpen = false
    @State var isTimePickerOpen = false
    @State var isNodeAdded = false
    @State var offset = 0.0
    @Namespace var aniamtion
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isRemainderPresented {
                    contentView
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
    }
}

struct RemainderView_Previews: PreviewProvider {
    static var previews: some View {
        RemainderView(viewModel: MainViewModel())
    }
}

extension RemainderView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Image.remainderIcon
                Text(L10n.setReminder)
                    .font(.poppins(.medium, size: 18))
                    .padding(.top)
                CounterView(counter: $viewModel.remainderCounter,
                            unit: $viewModel.subtitle,
                            color: $viewModel.remainderColor, isInvertedColor: true)
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
                        self.viewModel.isRemainderPresented = !(offset > 200)
                        self.offset = 0
                    }
                }
            )
        }.background(Color.clear)
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
                Text(L10n.addReminder)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.white)
            )
        }
        .padding(.top, 17)
    }
    var cancelButton: some View {
        Button {
            withAnimation {
                viewModel.isRemainderPresented = false
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
                        .padding(.top)
                }
            }
        }
    }
    var inputNoteOverlay: some View {
        HStack {
            Text(L10n.myNote)
                .font(.poppins(.medium, size: 14))
            TextField("", text: $viewModel.remainderNote)
                .font(.poppins(.bold, size: 14))
                .accentColor(Color.black)
                .multilineTextAlignment(.leading)
        }
        .foregroundColor(Color.black)
        .padding(.horizontal)
    }
}
