//
//  BGLevelAlertView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct BGLevelAlertView: View {
    @StateObject var viewModel: UserViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct BGLevelAlertView_Previews: PreviewProvider {
    static var previews: some View {
        BGLevelAlertView(viewModel: UserViewModel())
    }
}
