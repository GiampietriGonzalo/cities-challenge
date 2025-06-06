//
//  View+Rotate.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
