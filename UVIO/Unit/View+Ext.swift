//
//  View+Ext.swift
//  UVIO
//
//  Created by Macostik on 23.05.2022.
//

import Foundation
import SwiftUI

extension View {
  func toast(isShowing: Binding<Bool>) -> some View {
    self.modifier(ToastView(isShowing: isShowing))
  }
}
