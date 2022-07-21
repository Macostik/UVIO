//
//  MenuView.swift
//  UVIO
//
//  Created by Macostik on 09.06.2022.
//

import SwiftUI

struct MenuView: View {
    @Binding var isPresented: Bool
    @State var offset = 0.0
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
                                .transition(.move(edge: .bottom))
                            }
                        }
                    }
                .shadow(color: .gray.opacity(0.3), radius: 16, y: -10)
        }
}
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isPresented: .constant(true),
                 menuAction: { _ in })
    }
}

extension MenuView {
    var contentView: some View {
        VStack {
            VStack {
                Capsule()
                    .foregroundColor(Color.grayScaleColor)
                    .frame(width: 56, height: 4)
                    .padding(.top)
                Text(L10n.createEntry)
                    .font(.poppins(.medium, size: 18))
                buttonsContent
                closeButton
                    .padding(.bottom, 40)
            }
            .background(Color.white)
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
    var buttonsContent: some View {
        ScrollView([]) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(menuTypeList,
                        id: \.id) { item in
                    Button {
                        withAnimation {
                            isPresented = false
                        }
                        menuAction(item.menuAction)
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color.white)
                            .frame(height: 120)
                            .overlay(
                                VStack {
                                    item.icon
                                    Text(item.title)
                                        .foregroundColor(Color.black)
                                        .font(.poppins(.medium, size: 14))
                                }
                            )
                            .shadow(color: item.shadowColor, radius: 12, x: 0, y: 5)
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
