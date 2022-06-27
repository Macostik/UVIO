//
//  InputInsulinView.swift
//  UVIO
//
//  Created by Macostik on 27.06.2022.
//

import SwiftUI

struct InputInsulinView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
      contentView
    }
}

struct InputInsulinView_Previews: PreviewProvider {
    static var previews: some View {
        InputInsulinView(viewModel: MainViewModel())
    }
}

extension InputInsulinView {
    var contentView: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .background(Color.red)
    }
}
