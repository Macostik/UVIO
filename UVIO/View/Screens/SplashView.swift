//
//  SplashView.swift
//  UVIO
//
//  Created by Macostik on 16.05.2022.
//

import Foundation
import SwiftUI
import Combine

struct SplashView: View {
    
    @ObservedObject var viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Splash screen")
    }
}
