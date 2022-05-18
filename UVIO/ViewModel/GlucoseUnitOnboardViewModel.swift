//
//  GlucoseUnitOnboardViewModel.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

class GlucoseUnitOnboardViewModel: ObservableObject {
    
    @Published var selectedItem: GlucoseType? {
        willSet {
            guard let item = newValue else { return }
            glucoseTypeList.forEach({ $0.isSelected = false })
            glucoseTypeList.first(where: { $0.id == item.id })?.isSelected = true
        }
    }
    
    @Published  var glucoseRangeValue: ClosedRange<Int> = 100...160
    
    class GlucoseType {
        let id: Int
        let type: String
        var isSelected = false
        
        init(id: Int, type: String) {
            self.id = id
            self.type = type
        }
    }
    
     var glucoseTypeList = [
        GlucoseType(id: 1, type: "mg/dL"),
        GlucoseType(id: 2, type: "mmol/l"),
    ]
    
}
