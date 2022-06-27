//
//  CheckInTimeView.swift
//  UVIO
//
//  Created by Macostik on 27.06.2022.
//

import SwiftUI

struct CheckInTimeView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        contentView
    }
}

struct CheckInTimeView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInTimeView(viewModel: MainViewModel())
    }
}

extension CheckInTimeView {
    var contentView: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .background(Color.blue)
    }
}
