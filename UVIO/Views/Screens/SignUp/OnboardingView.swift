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
                ScrollView([]) {
                    TabView {
                        ForEach(onboardingViews.indices, id: \.self) { index in
                            viewModel.buildView(types: onboardingViews, index: index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .ignoresSafeArea()
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
