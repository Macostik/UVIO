//
//  MainView.swift
//  UVIO
//
//  Created by Macostik on 08.06.2022.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var mainViewModel: MainViewModel
    let columns = Array(repeating: GridItem(.flexible(minimum: 100), spacing: 0), count: 6)
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundView
            contentView
                .overlay(Rectangle()
                    .fill(mainViewModel.isPresented ? Color.black.opacity(0.3) : Color.clear))
                .ignoresSafeArea()
            menuView
            logBGView
            foodView
            insulinView
            remainderView
            if mainViewModel.isShownWarningAlert {
                warningView
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userViewModel: UserViewModel(), mainViewModel: MainViewModel())
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
            mainViewModel.listEntries.isEmpty ||
            mainViewModel.isShowInfoAlert
            VStack(spacing: isShownBottomPlaceholder ? 20 : 0) {
                NavigationBarView(destination: {
                    SettingsView(viewModel: userViewModel)
                }, content: {
                    Text(L10n.yourGlucose)
                        .font(.poppins(.bold, size: 18))
                })
                if !mainViewModel.isFullHistory {
                    topView
                        .frame(height: 325)
                }
                if !mainViewModel.isShowInfoAlert {
                    if mainViewModel.listEntries.isEmpty {
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
            if mainViewModel.isShowInfoAlert {
                InfoAlertView(viewModel: mainViewModel)
            } else {
                Button {
                    withAnimation {
                        mainViewModel.isMenuPresented = true
                    }
                } label: {
                    Image.plusButtonIcon
                        .offset(y: 50)
                        .shadow(color: Color.complementaryColor.opacity(0.5), radius: 20, y: 20)
                }
                .padding(.bottom, safeAreaInsets.bottom + 15)
            }
        }
    }
    var topView: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .overlay(topOverlay, alignment: .top)
            .padding(.horizontal)
    }
    var topOverlay: some View {
        ZStack {
            VStack {
                headerTopView
                    .padding(.top, 10)
                GraphView()
            }
        }
    }
    var bottomView: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.bottomBGColor)
            .overlay(bottomOverlay, alignment: .top)
            .padding(.horizontal)
            .padding(.bottom, safeAreaInsets.bottom - 10)
    }
    var bottomOverlay: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(mainViewModel.user.name)
                    .font(.poppins(.bold, size: 24))
                    .foregroundColor(Color.black)
                Text(L10n.pressPlus)
                    .font(.poppins(.regular, size: 18))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.leading)
                Image.spiralIcon
                    .padding(.top, 60)
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
                    ForEach(mainViewModel.listEntries, id: \.self) { listItem in
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
        ZStack(alignment: .top) {
            Divider()
                .frame(height: 1)
                .foregroundColor(Color.grayScaleColor)
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        mainViewModel.isFullHistory.toggle()
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
                    Text(mainViewModel.glucoseValue)
                        .foregroundColor(Color.greenSuccessColor)
                        .font(.poppins(.bold, size: 50))
                    Text(mainViewModel.glucoseCorrectionValue)
                        .font(.poppins(.medium, size: 14))
                }
                HStack {
                    Text(mainViewModel.glucoseUnitValue)
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
        MenuView(isPresented: $mainViewModel.isMenuPresented,
                 menuAction: { action in
            mainViewModel.menuActionPubliser.send(action)
        })
    }
    var logBGView: some View {
        LogBGLevelView(viewModel: mainViewModel)
    }
    var foodView: some View {
        FoodView(viewModel: mainViewModel)
    }
    var insulinView: some View {
        InsulinView(viewModel: mainViewModel)
    }
    var remainderView: some View {
        ReminderView(viewModel: mainViewModel)
    }
    var warningView: some View {
        WarningAlertView(viewModel: mainViewModel)
    }
}
