//
//  EmailSignUpViewModel.swift
//  UVIO
//
//  Created by Macostik on 19.05.2022.
//

import SwiftUI

class EmailSignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}
