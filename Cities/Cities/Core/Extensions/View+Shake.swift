//
//  View+Shake.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import SwiftUI

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

