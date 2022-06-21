//
//  SegmentControl.swift
//  UVIO
//
//  Created by Macostik on 21.06.2022.
//

import SwiftUI

struct SegmentControl: View {
    @Binding var selectedTab: String
    var title: String
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = title
            }
        }, label: {
            Text(title)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(isSelected ? selectedColor : Color.black)
                .padding(.vertical, 10)
                .frame(width: UIScreen.main.bounds.width/2 - 30)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                )
                .padding(.horizontal, 4)
        })
    }
    var isSelected: Bool {
        selectedTab == title
    }
    var selectedColor: Color {
        switch selectedTab {
        case L10n.logAction: return Color.primaryCayanColor
        case L10n.rapidAction: return Color.rapidOrangeColor
        default: return Color.black
        }
    }
}
