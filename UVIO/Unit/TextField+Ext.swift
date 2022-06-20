//
//  TextField+Ext.swift
//  UVIO
//
//  Created by Macostik on 17.06.2022.
//

import SwiftUI

struct TextFieldDone: UIViewRepresentable {
    @Binding var text: String
    var keyType: UIKeyboardType
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.keyboardType = keyType
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(textfield.doneButtonTapped(button:)))
        let flexableSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexableSpace, doneButton], animated: true)
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
extension  UITextField {
    @objc func doneButtonTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}
