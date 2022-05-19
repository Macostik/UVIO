//
//  StateButton.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import SwiftUI

struct SelectableButtonStyle: ButtonStyle {

    var isSelected = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(isSelected ? Color.complementaryColor : Color.black)
            .background(isSelected ? Color.clear : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
            .overlay(RoundedRectangle(cornerRadius: 16.0)
                .stroke(lineWidth: isSelected ? 2.0 : 0.0)
                .foregroundColor(Color.white))
    }
}


struct StatedButton<Label>: View where Label: View {

    private let action: (() -> ())?
    private let label: (() -> Label)?
    @State var buttonStyle = SelectableButtonStyle()

    init(action: (() -> ())? = nil, label: (() -> Label)? = nil) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: {
            self.buttonStyle.isSelected = !self.buttonStyle.isSelected
            self.action?()
        }) {
            label?()
        }
        .buttonStyle(buttonStyle)
    }
}
