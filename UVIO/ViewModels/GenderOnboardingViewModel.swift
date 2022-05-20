//
//  GenderOnboardingViewModel.swift
//  UVIO
//
//  Created by Macostik on 17.05.2022.
//

import SwiftUI
import Combine

class GenderOnboardingViewModel: ObservableObject {
    @Published var isSelectedSpecifyType = false
    @Published var ownType: String = ""
    @Published var selectedItem: GenderType? {
        willSet {
            guard let item = newValue else { return }
            genderTypeList.forEach({ $0.isSelected = false })
            let selectedItem = genderTypeList.first(where: { $0.id == item.id })
            if let selectedItem = selectedItem {
                isSelectedSpecifyType = selectedItem.id == 4
                selectedItem.isSelected = true
            }
        }
    }
    class GenderType {
        let id: Int
        let type: String
        var isSelected = false
        init(id: Int, type: String, isSelected: Bool) {
            self.id = id
            self.type = type
            self.isSelected = isSelected
        }
    }
     var genderTypeList = [
        GenderType(id: 1, type: L10n.female, isSelected: true),
        GenderType(id: 2, type: L10n.male, isSelected: false),
        GenderType(id: 3, type: L10n.nonBinary, isSelected: false),
        GenderType(id: 4, type: L10n.specifyAnother, isSelected: false)
    ]
}
