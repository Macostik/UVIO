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
    @State private var index: Int = 0 {
        didSet {
            print(index)
        }
    }
    @State private var offset: CGFloat = 0 
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                NativigationBackBarView {
                    ProgressView(completed: 0.2)
                }
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 0) {
                            ForEach(onboardingViews.indices, id: \.self) { index in
                                viewModel.buildView(types: onboardingViews, index: index)
                                    .frame(width: geometry.size.width)
                            }
                        }
                    }
                    .content.offset(x: self.offset)
                    .frame(width: geometry.size.width, height: nil, alignment: .leading)
                    .gesture(DragGesture()
                        .onChanged({ value in
                            self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                        })
                        .onEnded({ value in
                            if abs(value.predictedEndTranslation.width) >= geometry.size.width / 2 {
                                var nextIndex: Int = (value.predictedEndTranslation.width < 0) ? 1 : -1
                                nextIndex += self.index
                                self.index = nextIndex.keepIndexInRange(min: 0, max: onboardingViews.endIndex - 1)
                            }
                            withAnimation { self.offset = -geometry.size.width * CGFloat(self.index) }
                        })
                    )
                }
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
