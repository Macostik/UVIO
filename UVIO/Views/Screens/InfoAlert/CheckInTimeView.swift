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
                .offset(y: -5)
            Text(L10n.checkInTime)
                .foregroundColor(Color.black)
                .font(.poppins(.bold, size: 18))
                .padding(.bottom, 3)
                .offset(y: -15)
            Text(L10n.youReachedTargetRange)
                .foregroundColor(Color.greenSuccessColor)
                .font(.poppins(.bold, size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .offset(y: -22)
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(Color.white)
                .frame(height: 149)
                .overlay(checkInTimeOverlay)
                .padding(.horizontal)
                .offset(y: -20)
//            Button {
//            } label: {
//                ZStack {
//                    HStack {
//                        Image.nextIcon
//                            .padding()
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .trailing)
//                .background(Color.complementaryColor)
//                .cornerRadius(12)
//                .padding(.horizontal)
//                .overlay(buttonOverlay)
//                .offset(y: -12)
//            }
            Button {
                withAnimation {
                    viewModel.isShowInfoAlert = false
                }
            } label: {
                Text(L10n.close)
                    .foregroundColor(Color.black)
                    .font(.poppins(.medium, size: 14))
            }
            .padding(.top, 30)
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
                    Text(Date().time)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 10))
                    Text("5.0")
                        .foregroundColor(Color.primaryAlertColor)
                        .font(.poppins(.bold, size: 30))
                    Text(viewModel.glucoseUnit)
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
                    let reminderDate =
                    Calendar.current.date(byAdding: .minute,
                                          value: -viewModel.reminderCounter,
                                          to: Date()) ?? Date()
                    Text(reminderDate.time)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 10))
                    Text(viewModel.glucoseValue)
                        .foregroundColor(Color.primaryAlertColor)
                        .font(.poppins(.bold, size: 30))
                    Text(viewModel.glucoseUnit)
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
