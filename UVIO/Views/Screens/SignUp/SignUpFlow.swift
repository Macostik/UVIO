//
//  SignUpFlow.swift
//  UVIO
//
//  Created by Macostik on 13.06.2022.
//

import SwiftUI

struct SignUpFlow: View {
    @ObservedObject var viewModel: UserViewModel
    var body: some View {
        ZStack(alignment: .top) {
            backgroundColor
            containerViews
        }
        .navigationBarHidden(true)
        .toast(isShowing: $viewModel.showErrorAlert)
    }
}

struct SignUpFlow_Previews: PreviewProvider {
    static var previews: some View {
        SignUpFlow(viewModel: UserViewModel())
    }
}

extension SignUpFlow {
    var backgroundColor: some View {
        Group {
            if viewModel.selectedOnboardingItem == .singUp ||
                viewModel.selectedOnboardingItem == .emailSignUp {
                Image.loginViewBackground
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient(
                    colors: [Color.grayBackgroundColor],
                    startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
    }
    var containerViews: some View {
        VStack {
            NavigationBackBarViewAction(action: {
                withAnimation {
                    viewModel.selectedOnboardingItem = viewModel.previousOnboardingType
                }
            }, content: {
                ProgressView(completed: viewModel.completionValue)
            })
            TabView(selection: $viewModel.selectedOnboardingItem) {
                SignUpView(viewModel: viewModel)
                    .tag(OnboardingViewType.singUp)
                EmailSignUpView(viewModel: viewModel)
                    .tag(OnboardingViewType.emailSignUp)
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
