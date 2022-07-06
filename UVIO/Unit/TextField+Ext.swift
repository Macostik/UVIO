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
    class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        init(text: Binding<String>) {
            self.text = text
        }
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            guard let text = textField.text else { return false }
            if range.location == 3 {
                textField.text = (text.split(separator: ".").last ?? "0") + "."
            } else {
                textField.text = "0."
            }
            return true
        }
    }
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
        textfield.placeholder = "0.0"
        textfield.tintColor = UIColor.black
        textfield.font = UIFont(name: "Poppins-Bold", size: 80)
        textfield.textAlignment = .center
        textfield.keyboardType = keyType
        textfield.delegate = context.coordinator
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Done", style: .done) {
            text = textfield.text ?? "0.0"
            textfield.resignFirstResponder()
        }
        let flexableSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexableSpace, doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
}

private var actionKey: Void?

extension UIBarButtonItem {

    private var _action: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &actionKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self,
                                     &actionKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    convenience init(title: String?, style: UIBarButtonItem.Style, action: @escaping () -> Void) {
        self.init(title: title, style: style, target: nil, action: #selector(pressed))
        self.target = self
        self._action = action
    }

    @objc private func pressed(sender: UIBarButtonItem) {
        _action?()
    }
}

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
            }
            content
            .foregroundColor(Color.black)
        }
    }
}
