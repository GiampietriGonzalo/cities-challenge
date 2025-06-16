//
//  View+Keyboard.swift
//  Cities
//
//  Created by Gonza Giampietri on 16/06/2025.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                      to: nil,
                                      from: nil,
                                      for: nil)
    }
}
