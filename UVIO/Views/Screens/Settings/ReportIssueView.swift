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
        HStack {
        }
    }
}

struct ReportIssueView_Previews: PreviewProvider {
    static var previews: some View {
        ReportIssueView(viewModel: UserViewModel())
    }
}
