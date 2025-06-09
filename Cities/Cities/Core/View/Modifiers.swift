//
//  Modifiers.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

struct SearchViewModifier: ViewModifier {
    @Binding var searchText: String
    let prompt: String
    
    func body(content: Content) -> some View {
        content
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: prompt)
            .textInputAutocapitalization(.never)
    }
}
