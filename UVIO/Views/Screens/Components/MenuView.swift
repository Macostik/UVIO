//
//  MenuView.swift
//  UVIO
//
//  Created by Macostik on 09.06.2022.
//

import SwiftUI

struct MenuView: View {
    private var closeAction: () -> Void
    private var menuAction: (MenuAction) -> Void
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    init(menuAction: @escaping (MenuAction) -> Void,
         closeAction: @escaping () -> Void) {
        self.menuAction = menuAction
        self.closeAction = closeAction
    }
    var body: some View {
        ZStack {
            contentView
                .frame(height: UIScreen.main.bounds.height/2)
        }
        .clipShape(RoundedCorner(radius: 24,
                                 corners: [.topLeft, .topRight]))
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menuAction: { _ in },
                 closeAction: {})
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
    }
    var closeButton: some View {
        Button {
            closeAction()
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
