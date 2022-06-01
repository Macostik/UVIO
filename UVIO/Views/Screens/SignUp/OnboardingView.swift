//
//  OnboardingView.swift
//  UVIO
//
//  Created by Macostik on 31.05.2022.
//

import SwiftUI
import AVFoundation

struct OnboardingView: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundColor
            containerViews
        }
        .navigationBarHidden(true)
    }
    var backgroundColor: some View {
        LinearGradient(
            colors: [Color.grayBackgroundColor],
            startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
    var containerViews: some View {
        VStack {
            NativigationBackBarViewAction(action: {
                withAnimation {
                    viewModel.selectedItem = viewModel.previousType
                }
            }, content: {
                ProgressView(completed: viewModel.completionValue)
            })
            TabView(selection: $viewModel.selectedItem) {
                NameOnboardingView(viewModel: viewModel)
                    .tag(OnboardingViewType.name)
                BirthDateOnboardingView(viewModel: viewModel)
                    .tag(OnboardingViewType.birthDate)
                GenderOnboardingView(viewModel: viewModel)
                    .tag(OnboardingViewType.gender)
                GlucoseUnitOnboardingView(viewModel: viewModel)
                    .tag(OnboardingViewType.glucoseUnit)
                GlucoseAlertOnboardingView(viewModel: viewModel)
                    .tag(OnboardingViewType.glucoseAlert)
            }.tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: UserViewModel())
    }
}
