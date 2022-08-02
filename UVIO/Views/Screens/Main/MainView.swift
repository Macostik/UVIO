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
    @ObservedObject var mainViewModel = MainViewModel()
    @State var shouldScroll = true
    @State var title = L10n.yourGlucose
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
        MainView(userViewModel: UserViewModel())
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
                MainNavigationBarView(destination: {
                    SettingsView(viewModel: userViewModel)
                }, content: {
                    Text(title)
                        .font(.poppins(.bold, size: 18))
                })
                .padding(.bottom)
                if !mainViewModel.isFullHistory {
                    topView
                        .frame(height: 325)
                }
                if !mainViewModel.isShowInfoAlert {
                    if mainViewModel.listEntries.isEmpty &&
                        !mainViewModel.isFullHistory {
                        bottomView
                    } else {
                        listView
                            .background(Color.listGrayColor)
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
                GraphView(spacing: mainViewModel.listEntries.isEmpty ? 20 : 12)
                    .padding(.top, 22)
            }
        }
    }
    var bottomView: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color.clear)
            .overlay(bottomOverlay, alignment: .top)
            .padding(.horizontal, 8)
            .padding(.bottom, safeAreaInsets.bottom - 10)
    }
    var bottomOverlay: some View {
        ZStack {
            Image.mainBottomBackground
                .resizable()
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 0) {
                        Text(L10n.hi)
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(Color.black)
                        Text(mainViewModel.userName)
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(Color.black)
                        Text(",")
                            .font(.poppins(.bold, size: 24))
                            .foregroundColor(Color.black)
                    }
                    Text(L10n.pressPlus)
                        .font(.poppins(.regular, size: 16))
                        .foregroundColor(Color.black)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                    Image.spiralIcon
                        .padding(.top, 45)
                        .padding(.leading)
                }
                .padding(.leading, 20)
                .padding(.top)
                Spacer()
            }
        }
//        .padding(.top)
        .overlay(icecreamOverlay, alignment: .trailing)
    }
    private var axes: Axis.Set {
            return shouldScroll ? .vertical : []
        }
    var listView: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 40)
                .foregroundColor(Color.white)
            ScrollView(axes, showsIndicators: false) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    ForEach(mainViewModel.listEntries, id: \.self) { listItem in
                        Section(header:
                                    section(index: listItem.index,
                                            title: listItem.keyObject)) {
                            ForEach(listItem.valueObjects, id: \.self) { entry in
                                EntryView(listViewEntry: entry)
                            }
                        }
                    }
                }
                .padding(.bottom, safeAreaInsets.bottom)
            }
            historyOverlay
        }
    }
    private func section(index: Int, title: String) -> some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(Color.black)
                    .font(.poppins(.bold, size: 14))
                    .frame(height: 40)
                Spacer()
            }
            if mainViewModel.isShowCalendarHistory && index == 0 {
                DatePicker("", selection:
                            $mainViewModel.logBGWhenValue,
                           displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .background(Color.white)
                .cornerRadius(13)
                .animation(.easeInOut)
                .onChange(of: mainViewModel.logBGWhenValue) { _ in
                    withAnimation {
                        mainViewModel
                            .sortListEntries(by: mainViewModel.logBGWhenValue.convertToString())
                        mainViewModel.isShowCalendarHistory = false
                        shouldScroll = true
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(BlurView(style: .systemThinMaterialLight))
    }
    var historyOverlay: some View {
        ZStack(alignment: .top) {
            Divider()
                .frame(height: 1)
                .foregroundColor(Color.grayScaleColor)
            HStack {
                Spacer()
                Button {
                    title = mainViewModel.isFullHistory ? L10n.yourGlucose : L10n.history
                    withAnimation {
                        mainViewModel.isFullHistory.toggle()
                        mainViewModel.resoreListEntries()
                        shouldScroll = true
                        mainViewModel.isShowCalendarHistory = false
                    }
                } label: {
                    HStack {
                        Text(L10n.history)
                            .font(.poppins(.medium, size: 12))
                            .foregroundColor(Color.complementaryColor)
                    }
                }
                Button {
                    if mainViewModel.isFullHistory {
                        withAnimation {
                            shouldScroll = false
                            mainViewModel.isShowCalendarHistory.toggle()
                            mainViewModel.resoreListEntries()
                        }
                    }
                } label: {
                    Image.historyIcon
                }
            }
            .frame(height: 40)
            .padding(.trailing)
        }
    }
    var icecreamOverlay: some View {
        Image.icecreamIcon
            .padding()
            .offset(y: 20)
    }
    var headerTopView: some View {
        HStack {
            Capsule()
                .frame(width: 82, height: 32)
                .foregroundColor(Color.white)
                .overlay(dexcomOverlay)
                .padding(.leading, 20)
                .offset(y: 4)
            Spacer()
            Image.glucoseLevelArrow
                .resizable()
                .frame(width: 42, height: 42)
                .padding(.trailing, 59)
                .offset(y: 4)
        }
        .overlay(glucoseValueView)
        .frame(maxWidth: .infinity)
    }
    var glucoseValueView: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: -16) {
                Text(mainViewModel.glucoseValue)
                    .foregroundColor(Color.greenSuccessColor)
                    .font(.poppins(.bold, size: 50))
                    .offset(y: -5)
                Text(userViewModel.glucoseUnit)
                    .foregroundColor(Color.black)
                    .font(.poppins(.medium, size: 14))
                    .padding(.horizontal, 5)
            }
            .overlay( Text(mainViewModel.glucoseCorrectionValue)
                .font(.poppins(.medium, size: 14))
                .offset(x: 50, y: -18)
            )
        }
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
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
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
