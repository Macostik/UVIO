//
//  GraphView.swift
//  UVIO
//
//  Created by Macostik on 29.06.2022.
//

import SwiftUI

struct Points: Hashable {
    var value: CGFloat
    var color: Color {
        return value >= 10 || value <= 4 ? Color.red : Color.greenSuccessColor
    }
    var id = UUID().uuidString
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

let points: [Points] = [
    Points(value: 6),
    Points(value: 5),
    Points(value: 4),
    Points(value: 3.5),
    Points(value: 3.3),
    Points(value: 3.5),
    Points(value: 4),
    Points(value: 4.5),
    Points(value: 5),
    Points(value: 6),
    Points(value: 7),
    Points(value: 7),
    Points(value: 7),
    Points(value: 8),
    Points(value: 8),
    Points(value: 9),
    Points(value: 10),
    Points(value: 11),
    Points(value: 13),
    Points(value: 15),
    Points(value: 17),
    Points(value: 17.5),
    Points(value: 17.5),
    Points(value: 17),
    Points(value: 16),
    Points(value: 14),
    Points(value: 13),
    Points(value: 11),
    Points(value: 10),
    Points(value: 9.5),
    Points(value: 9),
    Points(value: 8),
    Points(value: 7),
    Points(value: 6.5),
    Points(value: 6),
    Points(value: 7),
    Points(value: 8),
    Points(value: 9),
    Points(value: 10),
    Points(value: 10.5),
    Points(value: 11),
    Points(value: 12),
    Points(value: 13),
    Points(value: 13.5)
]

struct GraphView: View {
    var body: some View {
        contentView
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

extension GraphView {
    var contentView: some View {
        ZStack(alignment: .top) {
            Group {
                ForEach(0..<points.count, id: \.self) { index in
                    let item = points[index]
                    let point = CGPoint(x: CGFloat((index + 1) * ((index == 0) ? 10 : 8)),
                                        y: (115 - item.value * 5))
                    Circle()
                        .foregroundColor(item.color)
                        .frame(width: 3, height: 3)
                        .position(point)
                }
            }
            VStack(spacing: 20) {
                ZStack {
                    VStack(alignment: .trailing, spacing: 18) {
                        HStack {
                            Text("21")
                            graphLine
                        }
                        HStack {
                            Text("15")
                            graphLine
                        }
                        HStack {
                            Text("9")
                            graphLine
                        }
                        HStack {
                            Text("3")
                            graphLine
                        }
                    }
                    .font(.poppins(.medium, size: 12))
                    Rectangle()
                        .frame(height: 32)
                        .foregroundColor(Color.greenSuccessColor.opacity(0.1))
                        .offset(x: 10, y: 20)
                        .padding(.trailing, 10)
                }
                HStack {
                    Group {
                        Text("4PM")
                        Spacer()
                        Text("5PM")
                        Spacer()
                        Text("6PM")
                    }
                    .padding(.leading)
                    .font(.poppins(.medium, size: 12))
                }
                HStack {
                    Group {
                        Text("1h")
                        Spacer()
                        Capsule()
                            .foregroundColor(
                                Color.grayScaleColor)
                            .overlay(Text("3h")
                            )
                            .frame(width: 40, height: 20)
                        Spacer()
                        Text("6h")
                        Spacer()
                        Text("12h")
                        Spacer()
                        Text("24h")
                    }
                }
                .font(.poppins(.medium, size: 12))
                .padding(.horizontal, 30)
            }
            .padding(.top)
            endPoint
        }
    }
    private var lastPoint: CGPoint {
        CGPoint(x: CGFloat(points.count *  8),
                y: (117 - (points.last?.value ?? 0) * 5))
    }
    private var lastPointColor: Color {
        points.last?.color ?? Color.greenSuccessColor
    }
    var endPoint: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundColor(lastPointColor)
            .overlay(
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(lastPointColor.opacity(0.3))
            )
            .position(lastPoint)
    }
    var graphLine: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1,
                                       dash: [5, 3],
                                       dashPhase: 1))
            .frame(height: 1)
            .foregroundColor(Color.capsulaGrayColor)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
