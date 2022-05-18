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
        DiabetType(id: 1, type: "Type 1 diabetes", isSelected: true),
        DiabetType(id: 2, type: "Type 2 diabetes", isSelected: false),
        DiabetType(id: 3, type: "Gestational diabetes", isSelected: false),
        DiabetType(id: 4, type: "Prediabetes", isSelected: false),
        DiabetType(id: 5, type: "LADA", isSelected: false),
        DiabetType(id: 6, type: "MODY", isSelected: false),
        DiabetType(id: 7, type: "I’m not sure which type I have", isSelected: false)
    ]
    
}
