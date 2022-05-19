//
//  CommonViews.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI

struct backButton: View  {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image.backButtonIcon
        }
    }
}

struct nextButton<V: View>: View {
    
    private var destination: V
    
    init(destination: V) {
        self.destination = destination
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                HStack() {
                    Image.nextIcon
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
            .background(Color.black)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(textOverlay)
        }
    }
    
    var textOverlay: some View {
        Text(L10n.next)
            .font(.poppins(.medium, size: 14))
            .foregroundColor(.white)
    }
}

struct skipButton: View {
    
    var body: some View {
        Button(action: {
            print("skip button click")
        }, label: {
            Text(L10n.skip)
                .font(.poppins(.medium, size: 14))
                .foregroundColor(Color.black)
        })
    }
}

func genderOverlay(type: String,
                   isSelected: Bool) -> some View {
    HStack {
        Circle()
            .foregroundColor(Color.grayscaleColor)
            .frame(width: 24, height: 24)
            .padding(.leading)
            .overlay(isSelected ?  Circle()
                .foregroundColor(Color.complementaryColor).frame(width: 12, height: 12).cornerRadius(6)
                .padding(.leading, 16) : nil)
        Text(type)
            .font(.poppins(.medium, size: 14))
        Spacer()
    }
}

struct progressView: View {
    
    var completed: Double = 1.0
    
    var body: some View {
        HStack(spacing: 18) {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: 160, height: 4)
                    .foregroundColor(Color.white)
                Capsule()
                    .frame(width: 160 * completed, height: 4)
                    .foregroundColor(Color.primaryGreenColor)
            }
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.primaryGreenColor)
                .frame(width: 12, height: 10)
        }
    }
}

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

