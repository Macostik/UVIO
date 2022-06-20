//
//  Date+Ext.swift
//  UVIO
//
//  Created by Macostik on 17.06.2022.
//

import Foundation

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Self())
    }
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: Self())
    }
}
