//
//  SingleSliderView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

//
//  RangedSliderView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI
import Combine

struct SingleSliderView: View {
    let currentValue: Binding<Int>
    let sliderBounds: ClosedRange<Int>
    
    public init(value: Binding<Int>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }
    
    var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }
    
        
    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color("primaryOrangeColor"))
                .frame(height: 4)
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)
                
                // thumb initial position
                let thumbLocation: CGFloat = currentValue.wrappedValue == Int(sliderBounds.lowerBound)
                    ? 0
                    : CGFloat(currentValue.wrappedValue - Int(sliderBounds.lowerBound)) * stepWidthInPixel
                
                
                // path between both handles
                lineBetweenThumbs(from: .init(x: 0, y: sliderViewYCenter),
                                  to: .init(x: thumbLocation, y: sliderViewYCenter))
                
                // thumb handle
                let thumbPoint = CGPoint(x: thumbLocation, y: sliderViewYCenter)
                thumbView(position: thumbPoint, value: currentValue.wrappedValue)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)
                        
                        currentValue.wrappedValue = Int(sliderBounds.lowerBound) + Int(xThumbOffset / stepWidthInPixel)
                    })
            }
        }
    }
    
    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(Color("primaryAlertColor"), lineWidth: 4)
    }
    
    @ViewBuilder func thumbView(position: CGPoint, value: Int) -> some View {
        ZStack {
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .overlay(Image("dotsIcon"))
            Text(String(value))
                .font(.custom("Poppings-Bold", size: 10))
                .foregroundColor(.black)
                .offset(y: 25)
        }
        .position(x: position.x, y: position.y)
    }
}

