//
//  MainView.swift
//  UVIO
//
//  Created by Macostik on 08.06.2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
                .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}

extension MainView {
    var backgroundView: some View {
        LinearGradient(
            colors: [Color.grayBackgroundColor],
            startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
    var contentView: some View {
        VStack(spacing: 20) {
            NativigationBarView(action: {}, content: {})
            topView
            bottomView
        }
    }
    var topView: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.white)
            .frame(width: .infinity)
            .overlay(topOverlay, alignment: .top)
            .padding(.horizontal)
    }
    var topOverlay: some View {
        ZStack {
            VStack {
                headerTopView
                graphView
                    .padding(.top, 10)
                Image.arrowBottomIcon
            }
        }
    }
    var bottomView: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(width: .infinity, height: 412)
            .foregroundColor(Color.bottomBGColor)
            .overlay(bottomOverlay, alignment: .top)
            .padding(.horizontal)
    }
    var bottomOverlay: some View {
        ZStack(alignment: .bottom) {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hi Georege,")
                    //            Text(viewModel.user.name)
                        .font(.poppins(.bold, size: 24))
                        .foregroundColor(Color.black)
                    Text(L10n.pressPlus)
                        .font(.poppins(.regular, size: 18))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    Image.spiralIcon
                }
                .padding()
                .padding(.leading)
                Spacer()
            }
            .padding(.top)
            .overlay(icecreamOverlay, alignment: .trailing)
            Button {
                viewModel.presentMenu = true
            } label: {
                Image.plusIcon
                    .offset(y: 50)
                    .shadow(color: Color.complementaryColor.opacity(0.5), radius: 20, y: 20)
            }
        }
    }
    var icecreamOverlay: some View {
        Image.icecreamIcon
            .padding()
    }
    var headerTopView: some View {
        HStack {
            VStack(alignment: .leading, spacing: -10) {
                HStack {
                    Text(viewModel.glucoseValue)
                        .foregroundColor(Color.primaryGreenColor)
                        .font(.poppins(.bold, size: 40))
                    Image.greenArrowIcon
                }
                HStack {
                    Text(viewModel.glucoseUnitValue)
                    //                    Text(viewModel.user.glucoseUnit)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 14))
                    Image.clockIcon
                        .foregroundColor(Color.grayScaleColor)
                    Text(viewModel.timeValue)
                        .foregroundColor(Color.grayScaleColor)
                        .font(.poppins(.medium, size: 12))
                }
            }
            Spacer()
            Capsule()
                .frame(width: 94, height: 32)
                .foregroundColor(Color.complementaryColor.opacity(0.1))
                .overlay(dexcomOverlay)
        }
        .padding()
    }
    var dexcomOverlay: some View {
        HStack {
            Image.bluetoothIcon
                .resizable()
                .frame(width: 7, height: 13)
            Text(L10n.dexcom)
                .font(.poppins(.bold, size: 12))
        }
        .foregroundColor(Color.complementaryColor)
    }
    var graphView: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .trailing, spacing: 18) {
                        Text("18")
                        Text("12")
                        Text("6")
                    }
                    .font(.poppins(.medium, size: 12))
                    .offset(y: -10)
                    VStack(spacing: 0) {
                        Divider()
                            .foregroundColor(Color.blue)
                            .padding(.bottom, 20)
                        Rectangle()
                            .foregroundColor(Color.primaryOrangeColor.opacity(0.2))
                            .frame(height: 20)
                        Rectangle()
                            .foregroundColor(Color.primaryGreenColor.opacity(0.2))
                            .frame(height: 40)
                        Rectangle()
                            .foregroundColor(Color.primaryOrangeColor.opacity(0.2))
                            .frame(height: 20)
                    }
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
                        Spacer()
                    }
                }
                .font(.poppins(.medium, size: 12))
                .padding(.leading)
            }
        }
        .padding()
    }
}
