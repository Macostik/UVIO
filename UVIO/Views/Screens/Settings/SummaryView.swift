//
//  SummaryView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct SummaryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            VStack {
                navigationBarView
                contentView
            }
        }
        .navigationBarHidden(true)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(viewModel: UserViewModel())
    }
}

extension SummaryView {
    var backgroundView: some View {
        Rectangle()
            .foregroundColor(Color.grayScaleColor)
            .ignoresSafeArea()
    }
    var navigationBarView: some View {
        NavigationBackBarViewAction(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, content: {
            ZStack {
                Text(L10n.mySummary)
                    .font(.poppins(.medium, size: 18))
            }
        }, backgroundColor: Color.white)
    }
    var contentView: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Yurii")
                        .font(.poppins(.medium, size: 24))
                    Text(L10n.itsYourSummary)
                        .font(.poppins(.medium, size: 18))
                }
                Button {
                } label: {
                    Text("Last 24h")
                        .font(.poppins(.medium, size: 12))
                        .frame(width: 124, height: 32)
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .clipShape(Capsule())
                }
            }
            HStack(spacing: 16) {
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .frame(height: 203)
                        .overlay(topLeftOverlay)
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 124)
                        .foregroundColor(Color.white)
                        .overlay(middleLeftOverlay)
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .frame(height: 124)
                        .overlay(bottomLeftOverlay)
                    Spacer()
                }
                .padding(.leading)
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .frame(height: 203)
                        .overlay(topRightOverlay)
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color.white)
                        .frame(height: 124)
                        .overlay(middleRightOverlay)
                    Spacer()
                }
                .padding(.trailing)
            }
        }
    }
    var topLeftOverlay: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(L10n.bgLevel)
                .font(.poppins(.bold, size: 16))
            Text(L10n.timeInTarget)
                .font(.poppins(.regular, size: 14))
                .foregroundColor(Color.gray)
            Spacer()
            HStack(alignment: .bottom) {
                Text("77%")
                    .font(.poppins(.regular, size: 40))
                    .foregroundColor(Color.greenSuccessColor)
                Spacer()
                Text(L10n.good)
                    .font(.poppins(.regular, size: 14))
            }
            Spacer()
            HStack {
                Text("20%")
                    .font(.poppins(.bold, size: 14))
                    .foregroundColor(Color.rapidOrangeColor)
                Spacer()
                Text(L10n.border)
                    .font(.poppins(.regular, size: 14))
            }
            HStack {
                Text("3%")
                    .font(.poppins(.bold, size: 14))
                    .foregroundColor(Color.primaryAlertColor)
                Spacer()
                Text(L10n.hyperHype)
                    .font(.poppins(.regular, size: 14))
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    var topRightOverlay: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(L10n.avgBG)
                .font(.poppins(.bold, size: 16))
            Text(L10n.mmolL)
                .font(.poppins(.regular, size: 14))
                .foregroundColor(Color.gray)
            Spacer()
            Text("134.8")
                .font(.poppins(.regular, size: 40))
                .foregroundColor(Color.greenSuccessColor)
            Spacer()
            HStack {
                Text(L10n.via)
                    .font(.poppins(.regular, size: 14))
                Image.dexcomIcon
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    var middleLeftOverlay: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
            }
            Text(L10n.highBgLog)
                .font(.poppins(.bold, size: 16))
            Spacer()
            Text("2")
                .font(.poppins(.regular, size: 40))
                .foregroundColor(Color.primaryAlertColor)
            Spacer()
        }
        .padding(.horizontal)
    }
    var middleRightOverlay: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
            }
            Text(L10n.lowBgLog)
                .font(.poppins(.bold, size: 16))
            Spacer()
            Text("1")
                .font(.poppins(.regular, size: 40))
                .foregroundColor(Color.primaryAlertColor)
            Spacer()
        }
        .padding(.horizontal)
    }
    var bottomLeftOverlay: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
            }
            Text(L10n.est)
                .font(.poppins(.bold, size: 16))
            Spacer()
            Text("6.9%")
                .font(.poppins(.regular, size: 40))
                .foregroundColor(Color.greenSuccessColor)
            Spacer()
        }
        .padding(.horizontal)
    }
}
