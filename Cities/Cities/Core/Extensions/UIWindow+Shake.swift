//
//  UIWindow+Shake.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import SwiftUI

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}
