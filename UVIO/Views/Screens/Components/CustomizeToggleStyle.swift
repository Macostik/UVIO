//
//  ToggleStyle.swift
//  UVIO
//
//  Created by Macostik on 01.06.2022.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule()
                .frame(width: 36, height: 20)
                .foregroundColor(configuration.isOn ? Color.primaryGreenColor : Color.grayScaleColor)
                .overlay(
                    Circle()
                        .foregroundColor(Color.white)
                        .frame(width: 14, height: 14)
                        .padding(configuration.isOn ? .trailing : .leading, 3),
                    alignment: configuration.isOn ? .trailing : .leading)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
