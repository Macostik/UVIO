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
            VStack {
                NativigationBackBarView {
                    ProgressView(completed: 0.2)
                }
                TabView(selection: $viewModel.selectedItem) {
                    NameOnboardingView(viewModel: viewModel)
                        .tag(OnboardingViewType.name)
                    BirthDateOnboardingView(viewModel: viewModel)
                        .tag(OnboardingViewType.birthDate)
                    GenderOnboardingView(viewModel: viewModel)
                        .tag(OnboardingViewType.gender)
                    GlucoseUnitOnboardingView(viewModel: viewModel)
                        .tag(OnboardingViewType.glucose)
                }.tabViewStyle(.page)
            }
        }
        .navigationBarHidden(true)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: UserViewModel())
    }
}
