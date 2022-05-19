//
//  GlucoseUnitOnboardViewModel.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

class GlucoseUnitOnboardViewModel: ObservableObject {
    @Published var glucoseRangeValue: ClosedRange<Int> = 100...160
    @Published var hyperValue: Int = 200
    @Published var hypoValue: Int = 70
    @Published var selectedItem: GlucoseType? {
        willSet {
            guard let item = newValue else { return }
            glucoseTypeList.forEach({ $0.isSelected = false })
            glucoseTypeList.first(where: { $0.id == item.id })?.isSelected = true
        }
    }
    class GlucoseType {
        let id: Int
        let type: String
        var isSelected: Bool
        init(id: Int, type: String, isSelected: Bool) {
            self.id = id
            self.type = type
            self.isSelected = isSelected
        }
    }
     var glucoseTypeList = [
        GlucoseType(id: 1, type: L10n.mgDL, isSelected: true),
        GlucoseType(id: 2, type: L10n.mmolL, isSelected: false)
    ]
}
