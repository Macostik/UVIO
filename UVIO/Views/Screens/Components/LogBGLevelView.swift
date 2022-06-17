//
//  LogBGLevelView.swift
//  UVIO
//
//  Created by Macostik on 17.06.2022.
//

import SwiftUI

struct LogBGLevelView: View {
    @Binding var isPresented: Bool
    @Binding var inputValue: String
    @State var offset = 0.0
    var menuAction: (MenuAction) -> Void
    var body: some View {
                ZStack {
                    VStack {
                        if isPresented {
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
        LogBGLevelView(isPresented: .constant(true),
                       inputValue: .constant("0.0"),
                       menuAction: { _ in })
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
                inputContainer
                whenContainer
                timeContainer
                Text(L10n.addNote)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.complementaryColor)
                    .padding(.top)
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
                    if yOffset > 0 {
                        offset = yOffset
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        self.isPresented = !(offset > 200)
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
            TextField("", text: $inputValue)
                .font(.poppins(.bold, size: 80))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.capsulaGrayColor)
            Text(L10n.mmolL)
                .font(.poppins(.medium, size: 18))
            Text(L10n.glucose)
                .font(.poppins(.bold, size: 18))
        }
    }
    var whenContainer: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(whenOverlay, alignment: .leading)
                .frame(height: 48)
                .padding(.horizontal)
        }
    }
    var whenOverlay: some View {
        HStack {
            Text(L10n.when)
                .font(.poppins(.medium, size: 14))
            Text(L10n.when)
                .font(.poppins(.medium, size: 14))
        }
        .padding()
    }
    var timeContainer: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
                .overlay(timeOverlay, alignment: .leading)
                .frame(height: 48)
                .padding(.horizontal)
        }
    }
    var timeOverlay: some View {
        HStack {
            Text(L10n.time)
                .font(.poppins(.medium, size: 14))
            Text(L10n.time)
                .font(.poppins(.medium, size: 14))
        }
        .padding()
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
                Text(L10n.submitBGLog)
                    .font(.poppins(.medium, size: 14))
                    .foregroundColor(Color.white)
            )
        }
        .padding(.top, 17)
    }
    var cancelButton: some View {
        Button {
        } label: {
            Text(L10n.cancel)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
                .frame(height: 48)
            .padding(.horizontal)
        }
    }
}
