//
//  DatePicker+Ext.swift
//  UVIO
//
//  Created by Macostik on 20.06.2022.
//

import SwiftUI

typealias PickerListEntryType = [String]

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

struct RangeDatePicker: UIViewRepresentable {
    @Binding var selectedItem: Date
    class Coordinator: NSObject {
        var selectedItem: Binding<Date>
        init(selectedItem: Binding<Date>) {
          self.selectedItem = selectedItem
        }
        @objc func handleDatePicker(_ datePicker: UIDatePicker) {
            selectedItem.wrappedValue = datePicker.date
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedItem: $selectedItem)
    }
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -122, to: Date())
        picker.maximumDate = Date()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(context.coordinator, action: #selector(Coordinator.handleDatePicker), for: .valueChanged)
        return picker
    }
    func updateUIView(_ picker: UIDatePicker, context: Context) {}
}
