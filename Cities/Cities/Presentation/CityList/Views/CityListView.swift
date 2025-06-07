//
//  CityListView.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI

struct CityListView: View {
    
    var mapViewModel: MapViewModelProtocol?
    @State var viewModel: CityListViewModelProtocol
    @State private var deviceOrientation: UIDeviceOrientation = .unknown
    @State private var mapViewData: MapViewData = .empty
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                Text("Loading...")
                    .task {
                        await viewModel.load()
                    }
            case let .loaded(viewData):
                buildCityScreen(cities: viewData.cityLocations, mapViewData: viewData.mapViewData)
            case .onError(let error):
                Text("Error: \(error)")
            }
        }
        .onChange(of: viewModel.state) {
            guard deviceOrientation.isLandscape,
                  case .loaded(let viewData) = viewModel.state, let mapViewData = viewData.mapViewData else { return }
            self.mapViewData = mapViewData
        }
        .onRotate { newOrientation in
            deviceOrientation = newOrientation
            debugPrint(deviceOrientation.rawValue)
        }
        .toolbar(deviceOrientation.isLandscape ? .hidden : .automatic)
    }
    
    @ViewBuilder
    func buildCityScreen(cities: [CityLocationViewData], mapViewData: MapViewData?) -> some View {
        if deviceOrientation.isLandscape, let mapViewData = mapViewData {
            buildCityListWithMap(cities: cities, mapViewData: mapViewData)
        } else {
            buildCityList(cities: cities)
        }
    }
    
    func buildCityListWithMap(cities: [CityLocationViewData], mapViewData: MapViewData) -> some View {
        HStack(spacing: 0) {
            buildCityList(cities: cities)
                .frame(width: 250)
            MapView(viewData: $mapViewData,
                    displayCitySelector: !deviceOrientation.isLandscape)
        }
    }
    
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        List {
            ForEach(cities) { city in
                CityCellView(city: city)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        city.onSelect(deviceOrientation.isLandscape)
                    }
                    
            }
        }
        .listStyle(.plain)
        .ignoresSafeArea()
    }
}

#Preview {
    CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
}
