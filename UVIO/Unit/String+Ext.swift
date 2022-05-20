//
//  String+Ext.swift
//  UVIO
//
//  Created by Macostik on 20.05.2022.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]" +
        "(?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[" +
        "a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                 options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [],
                                    range: NSRange(location: 0,
                                                   length: count)) != nil
        } catch {
            return false
        }
    }
}
