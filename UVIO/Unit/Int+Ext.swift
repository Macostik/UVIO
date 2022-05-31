//
//  Int+Ext.swift
//  UVIO
//
//  Created by Macostik on 31.05.2022.
//

import Foundation

extension Int {
    func keepIndexInRange(min: Int, max: Int) -> Int {
        switch self {
        case ..<min: return min
        case max...: return max
        default: return self
        }
    }
}
