//
//  MapView.swift
//  Cities
//
//  Created by Gonza Giampietri on 04/06/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var viewModel: MapViewModelProtocol
    
    var body: some View {
        VStack {
            Map(position: $viewModel.viewData.position) {
                
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }
            .mapStyle(.standard(elevation: .realistic))
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(viewModel.viewData.cities) { city in
                        Button {
                            
                        } label: {
                            Text(city.name)
                                .font(.body.weight(.medium))
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(.white)
                        .background(Color.black)
                        .clipShape(.capsule)
                        .padding(.horizontal, 4)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                .blur(radius: phase.isIdentity ? 0 : 0.5)
                        }
                    }
                }
                
            }
            .padding(.top, 10)
            .scrollIndicators(.hidden)
            .frame(height: 48)
            .background(.blue)

        }
        .background(.blue)
        
    }
}

#Preview {
    MapView(viewModel: AppContainer.shared.buildMapViewModel(using: [.mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock]))
}
