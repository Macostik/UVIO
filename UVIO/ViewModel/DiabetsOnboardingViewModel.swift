//
//  DiabetsOnboardingViewModel.swift
//  UVIO
//
//  Created by Macostik on 18.05.2022.
//

import SwiftUI

class DiabetsOnboardingViewModel: ObservableObject {
    
    @Published var selectedItem: DiabetType? {
        willSet {
            guard let item = newValue else { return }
            diabetTypeList.forEach({ $0.isSelected = false })
            diabetTypeList.first(where: { $0.id == item.id })?.isSelected = true
        }
    }
    
    class DiabetType {
        let id: Int
        let type: String
        var isSelected = false
        
        init(id: Int, type: String, isSelected: Bool) {
            self.id = id
            self.type = type
            self.isSelected = isSelected
        }
    }
    
     var diabetTypeList = [
        DiabetType(id: 1, type: L10n.type1Diabetes, isSelected: true),
        DiabetType(id: 2, type: L10n.type2Diabetes, isSelected: false),
        DiabetType(id: 3, type: L10n.gestationalDiabetes, isSelected: false),
        DiabetType(id: 4, type: L10n.prediabetes, isSelected: false),
        DiabetType(id: 5, type: L10n.lada, isSelected: false),
        DiabetType(id: 6, type: L10n.mody, isSelected: false),
        DiabetType(id: 7, type: L10n.iNotSure, isSelected: false)
    ]
    
}
