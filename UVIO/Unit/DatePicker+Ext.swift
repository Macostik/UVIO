//
//  DatePicker+Ext.swift
//  UVIO
//
//  Created by Macostik on 20.06.2022.
//

import SwiftUI

typealias PickerListEntryType = [String]

enum CarbsPickerData: StringLiteralType, CaseIterable {
    case c15, c30, c45, c60, c75, c90
    var description: String {
        switch self {
        case .c15: return "15 carbs"
        case .c30: return "30 carbs"
        case .c45: return "45 carbs"
        case .c60: return "60 carbs"
        case .c75: return "75 carbs"
        case .c90: return "90 carbs"
        }
    }
}

struct CarbsDataPicker: UIViewRepresentable {
    @Binding var selectedItem: String
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var selectedItem: Binding<String>
        init(selectedItem: Binding<String>) {
          self.selectedItem = selectedItem
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            1
        }
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            CarbsPickerData.allCases.count
        }
        func pickerView(_ pickerView: UIPickerView,
                        titleForRow row: Int,
                        forComponent component: Int) -> String? {
            CarbsPickerData.allCases[row].description
        }
        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
            self.selectedItem.wrappedValue = CarbsPickerData.allCases[row].description
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedItem: $selectedItem)
    }
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIView(_ picker: UIPickerView, context: Context) {}
}
