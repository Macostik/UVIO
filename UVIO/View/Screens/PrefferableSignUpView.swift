//
//  PrefferableSignUpView.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI
import Combine

struct PrefferableSignUpView: View {
    
    @ObservedObject private var viewModel: PreferrableSignUpViewModel
    
    init(viewModel: PreferrableSignUpViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image.loginViewBackground
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .bottom) {
                VStack(spacing: 16) {
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton())
    }
}

struct PrefferableSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        PrefferableSignUpView(viewModel: PreferrableSignUpViewModel())
    }
}
