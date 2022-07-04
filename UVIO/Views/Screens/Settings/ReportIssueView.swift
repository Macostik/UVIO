//
//  ReportIssueView.swift
//  UVIO
//
//  Created by Macostik on 04.07.2022.
//

import SwiftUI

struct ReportIssueView: View {
    @StateObject var viewModel: UserViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ReportIssueView_Previews: PreviewProvider {
    static var previews: some View {
        ReportIssueView(viewModel: UserViewModel())
    }
}
