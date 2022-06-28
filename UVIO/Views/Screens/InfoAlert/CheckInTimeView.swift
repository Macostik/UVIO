//
//  CheckInTimeView.swift
//  UVIO
//
//  Created by Macostik on 27.06.2022.
//

import SwiftUI

struct CheckInTimeView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        contentView
    }
}

struct CheckInTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInTimeView(viewModel: MainViewModel())
    }
}

extension CheckInTimeView {
    var contentView: some View {
        VStack {
            Image.timerIcon
            Text(L10n.checkInTime)
                .foregroundColor(Color.black)
                .font(.poppins(.bold, size: 18))
            Text(L10n.yourInsulinIsStillHigh)
                .foregroundColor(Color.primaryAlertColor)
                .font(.poppins(.bold, size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(Color.white)
                .frame(height: 149)
                .overlay(checkInTimeOverlay)
                .padding(.horizontal)
            NavigationLink(destination: {
            }, label: {
                ZStack {
                    HStack {
                        Image.nextIcon
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
                .background(Color.complementaryColor)
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(buttonOverlay)
            })
            Button {
            } label: {
                Text(L10n.skipForNow)
                    .foregroundColor(Color.black)
                    .font(.poppins(.medium, size: 14))
            }
            .padding(.top, 12)

        }
    }
    var buttonOverlay: some View {
        Text(L10n.logInsulin)
            .foregroundColor(Color.white)
            .font(.poppins(.medium, size: 14))
    }
    var checkInTimeOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Text("1:30 pm")
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 10))
                    Text("238")
                        .foregroundColor(Color.primaryAlertColor)
                        .font(.poppins(.bold, size: 30))
                    Text(L10n.mgDL)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 14))
                }
                Spacer()
                VStack {
                    HStack {
                        Divider()
                            .foregroundColor(Color.grayScaleColor)
                    }
                    Image.blackCircleArrowIcon
                    HStack {
                        Divider()
                            .foregroundColor(Color.grayScaleColor)
                    }
                }
                Spacer()
                VStack {
                    Text("2:45 pm")
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 10))
                    Text("211")
                        .foregroundColor(Color.primaryAlertColor)
                        .font(.poppins(.bold, size: 30))
                    Text(L10n.mgDL)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 14))
                }
                Spacer()
            }
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder()
                .foregroundColor(Color.grayScaleColor)
                .overlay(roundOverlay)
                .frame(height: 42)
                .padding(.bottom, 4)
                .padding(.horizontal, 4)
        }
    }
    var roundOverlay: some View {
        HStack {
            Text(L10n.insulinLogged)
                .foregroundColor(Color.black)
                .font(.poppins(.medium, size: 10))
            Spacer()
            Text("5 units")
                .foregroundColor(Color.black)
                .font(.poppins(.bold, size: 12))
            Capsule()
                .foregroundColor(Color.blue.opacity(0.05))
                .frame(width: 73, height: 16)
                .overlay(
                    Text(L10n.rapidAction)
                    .foregroundColor(Color.black)
                    .font(.poppins(.medium, size: 10))
                )
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal)
    }
}
