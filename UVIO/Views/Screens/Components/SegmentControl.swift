//
//  SegmentControl.swift
//  UVIO
//
//  Created by Macostik on 21.06.2022.
//

import SwiftUI

struct SegmentControl: View {
    @Binding var selectedTab: InsulinAction
    var title: InsulinAction
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation {
                selectedTab = title
            }
        }, label: {
            Text(title.action)
                .font(.poppins((title == selectedTab ? .bold : .medium), size: 14))
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
        case .long: return Color.primaryCayanColor
        case .rapid: return Color.rapidOrangeColor
        }
    }
}
