//
//  MenuView.swift
//  UVIO
//
//  Created by Macostik on 09.06.2022.
//

import SwiftUI

struct MenuView: View {
    @Binding var isPresented: Bool
    var menuAction: (MenuAction) -> Void
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    var body: some View {
                ZStack {
                    VStack {
                        if isPresented {
                            contentView
                                .padding(.bottom, 40)
                                .background(Color.white)
                                .transition(.move(edge: .bottom))
                            }
                        }
                    }
//                .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
        }
}
struct JustTheSlider: View {
    @Binding var val: Double
    var body: some View {
        VStack {
            Text("Slider")
                .font(.title)
            HStack {
                Text("Value: ")
                    .frame(minWidth: 80, alignment: .leading)
                Slider(value: $val, in: 0...30, step: 1)
                Text("\(Int(val))")
                    .frame(minWidth: 20, alignment: .trailing)
                    .font(Font.body.monospacedDigit())
                    .padding(.horizontal)
            }
        }
    }
}
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isPresented: .constant(false),
                 menuAction: { _ in })
    }
}

extension MenuView {
    var contentView: some View {
        VStack {
            Capsule()
                .foregroundColor(Color.grayScaleColor)
                .frame(width: 56, height: 4)
                .padding(.top)
            Text(L10n.createEntry)
                .font(.poppins(.medium, size: 18))
            buttonsContent
            closeButton
        }
        .clipShape(RoundedCorner(radius: 24,
                                  corners: [.topLeft, .topRight]))
    }
    var buttonsContent: some View {
        ScrollView([]) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(menuTypeList,
                        id: \.id) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .frame(height: 120)
                        .overlay(
                            VStack {
                                item.icon
                                Text(item.title)
                                    .foregroundColor(Color.black)
                                    .font(.poppins(.medium, size: 14))
                                    .padding(.leading)
                            }
                        )
                        .shadow(color: item.shadowColor, radius: 12, x: 0, y: 5)
                        .onTapGesture {
                            menuAction(item.menuAction)
                        }
                }
            }
            .padding()
        }
        .frame(height: 284)
    }
    var closeButton: some View {
        Button {
            withAnimation {
                isPresented = false
            }
        } label: {
            Rectangle()
                .foregroundColor(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.grayScaleColor, lineWidth: 4)
                        .frame(width: 52, height: 52)
                )
                .frame(width: 56, height: 56)
                .overlay(Image.closeIcon)
        }
    }
}
