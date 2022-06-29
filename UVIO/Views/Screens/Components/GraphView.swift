//
//  GraphView.swift
//  UVIO
//
//  Created by Macostik on 29.06.2022.
//

import SwiftUI

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
            Path { path in
                path.move(to: CGPoint(x: 10, y: 80))
                path.addCurve(to: CGPoint(x: 80, y: 80),
                              control1: CGPoint(x: 40, y: 60),
                              control2: CGPoint(x: 25, y: 200)
                )
                path.addCurve(to: CGPoint(x: 200, y: 100),
                              control1: CGPoint(x: 100, y: 50),
                              control2: CGPoint(x: 150, y: 100 )
                )
                path.addCurve(to: CGPoint(x: UIScreen.main.bounds.width - 50, y: 20),
                              control1: CGPoint(x: 300, y: 100),
                              control2: CGPoint(x: 250, y: 0)
                )
            }
            .stroke(style: StrokeStyle(lineWidth: 3,
                                       lineCap: .round,
                                       lineJoin: .round,
                                       dash: [0.1, 8],
                                       dashPhase: 1))
            .fill(Color.greenSuccessColor)
            VStack(spacing: 15) {
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
                        Text("3h")
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
            .padding(.trailing)
            endPoint
        }
    }
    var endPoint: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundColor(Color.greenSuccessColor)
            .overlay(
                Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(Color.greenSuccessColor.opacity(0.3))
            )
            .position(CGPoint(x: UIScreen.main.bounds.width - 45, y: 20))
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
