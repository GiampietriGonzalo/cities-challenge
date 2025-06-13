//
//  LoadingView.swift
//  Cities
//
//  Created by Gonza Giampietri on 13/06/2025.
//

import SwiftUI

struct LoadingView:View {
    var body: some View {
        ProgressView {
            Text(Strings.Common.loading)
        }
    }
}
