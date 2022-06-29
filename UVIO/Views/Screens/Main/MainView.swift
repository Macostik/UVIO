//
//  MainView.swift
//  UVIO
//
//  Created by Macostik on 08.06.2022.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    let columns = Array(repeating: GridItem(.flexible(minimum: 100), spacing: 0), count: 6)
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundView
            contentView
                .overlay(Rectangle()
                    .fill(viewModel.isPresented ? Color.black.opacity(0.3) : Color.clear))
                .ignoresSafeArea()
            menuView
            logBGView
            foodView
            insulinView
            remainderView
            if viewModel.isShownWarningAlert {
                warningView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
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
            colors: [Color.white],
            startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
    var contentView: some View {
        ZStack(alignment: .bottom) {
            let isShownBottomPlaceholder =
            viewModel.listEntries.isEmpty ||
            viewModel.isShowInfoAlert
            VStack(spacing: isShownBottomPlaceholder ? 20 : 0) {
                NativigationBarView(action: {}, content: {
                    Text(L10n.yourGlucose)
                        .font(.poppins(.bold, size: 18))
                })
                if !viewModel.isFullHistory {
                    topView
                        .frame(height: 325)
                }
                if !viewModel.isShowInfoAlert {
                    if viewModel.listEntries.isEmpty {
                        bottomView
                    } else {
                        listView
                            .background(Color.grayBackgroundColor)
                    }
                } else {
                    Spacer()
                }
            }
            .padding(.top, safeAreaInsets.top)
            if viewModel.isShowInfoAlert {
                InfoAlertView(viewModel: viewModel)
            } else {
                Button {
                    withAnimation {
                        viewModel.isMenuPresented = true
                    }
                } label: {
                    Image.plusButtonIcon
                        .offset(y: 50)
                        .shadow(color: Color.complementaryColor.opacity(0.5), radius: 20, y: 20)
                }
                .padding(.bottom, safeAreaInsets.bottom)
            }
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
                    .padding(.top, 30)
                GraphView()
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
    }
    var listView: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .foregroundColor(Color.white)
            ScrollView(.vertical) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ForEach(viewModel.listEntries, id: \.self) { listItem in
                        Section(header: section(listItem.keyObject, color: listItem.color)) {
                            ForEach(listItem.valueObjects, id: \.self) { entry in
                                EntryView(listViewEntry: entry)
                            }
                        }
//                        .onDisappear {
//                            if let currentIndex = viewModel.listEntries.firstIndex(of: listItem) {
//                                viewModel.listEntries[currentIndex + 1].color = Color.white
//                            }
//                        }
                    }
                }
                .padding(.bottom, safeAreaInsets.bottom)
            }
            historyOverlay
        }
    }
    private func section(_ title: String, color: Color) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color.black)
                .font(.poppins(.bold, size: 14))
                .frame(height: 40)
            Spacer()
        }
//        .background(color)
        .padding(.horizontal)
    }
    var historyOverlay: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    viewModel.isFullHistory.toggle()
                }
            } label: {
                HStack {
                    Text(L10n.history)
                        .font(.poppins(.medium, size: 12))
                        .foregroundColor(Color.complementaryColor)
                    Image.historyIcon
                }
            }
        }
        .frame(height: 40)
        .padding(.trailing)
    }
    var icecreamOverlay: some View {
        Image.icecreamIcon
            .padding()
    }
    var headerTopView: some View {
        HStack {
            Capsule()
                .frame(width: 82, height: 32)
                .foregroundColor(Color.white)
                .overlay(dexcomOverlay)
            Spacer()
            VStack(alignment: .leading, spacing: -10) {
                HStack(alignment: .top, spacing: 0) {
                    Text(viewModel.glucoseValue)
                        .foregroundColor(Color.greenSuccessColor)
                        .font(.poppins(.bold, size: 50))
                    Text(viewModel.glucoseCorrectionValue)
                        .font(.poppins(.medium, size: 14))
                }
                HStack {
                    Text(viewModel.glucoseUnitValue)
                    //                    Text(viewModel.user.glucoseUnit)
                        .foregroundColor(Color.black)
                        .font(.poppins(.medium, size: 14))
                        .padding(.horizontal, 5)
                }
            }
            Spacer()
            Image.glucoseLevelArrow
        }
        .padding(.horizontal, 40)
    }
    var dexcomOverlay: some View {
        ZStack {
            HStack {
                Image.bluetoothIcon
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 7, height: 13)
                Text(L10n.online)
                    .font(.poppins(.medium, size: 12))
            }
            .foregroundColor(Color.black)
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.capsulaGrayColor, lineWidth: 1)
        }
    }
    var menuView: some View {
        MenuView(isPresented: $viewModel.isMenuPresented,
                 menuAction: { action in
            viewModel.menuActionPubliser.send(action)
        })
    }
    var logBGView: some View {
        LogBGLevelView(viewModel: viewModel)
    }
    var foodView: some View {
        FoodView(viewModel: viewModel)
    }
    var insulinView: some View {
        InsulinView(viewModel: viewModel)
    }
    var remainderView: some View {
        ReminderView(viewModel: viewModel)
    }
    var warningView: some View {
        WarningAlertView(viewModel: viewModel)
    }
}
