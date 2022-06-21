//
//  CounterView.swift
//  UVIO
//
//  Created by Macostik on 21.06.2022.
//

import SwiftUI

struct CounterView: View {
    @Binding var counter: Int
    @Binding var unit: String
    @Binding var color: Color
    var body: some View {
        HStack(spacing: 25) {
            plusButtonView
            counerContainer
            minusButtonView
        }
        .padding(.vertical)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(counter: .constant(1),
                    unit: .constant("unit"),
                    color: .constant(Color.rapidOrangeColor))
    }
}

extension CounterView {
    var plusButtonView: some View {
        Button {
            counter += 1
        } label: {
            Image.plusIcon
                .frame(width: 40, height: 48)
                .background(color)
                .cornerRadius(8)
        }
    }
    var minusButtonView: some View {
        Button {
            counter -= 1
        } label: {
            Image.minusIcon
                .frame(width: 40, height: 48)
                .background(color)
                .cornerRadius(8)
        }
    }
    var counerContainer: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(Color.grayScaleColor)
            .frame(width: 140, height: 88)
            .overlay(counterOverlay)
    }
    var counterOverlay: some View {
        VStack(spacing: -10) {
            Text("\(counter)")
                .font(.poppins(.bold, size: 50))
            Text(unit)
                .font(.poppins(.medium, size: 14))
        }
    }
}