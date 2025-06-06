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
    @State private var deviceOrientation = UIDeviceOrientation.unknown
    @State private var mapViewData: MapViewData = .empty
    
    var body: some View {
        Group {
            switch viewModel.viewData.state {
            case .loading:
                Text("Loading...")
                    .task {
                        await viewModel.load()
                    }
            case let .loaded(cities, mapViewData):
                buildCityScreen(cities: cities, mapViewData: mapViewData)
            case .onError(let error):
                Text("Error: \(error)")
            }
        }
        .onChange(of: viewModel.viewData) {
            guard case .loaded(_, let mapViewData) = viewModel.viewData.state, let mapViewData else { return }
            self.mapViewData = mapViewData
        }
        .onRotate { newOrientation in
            deviceOrientation = newOrientation
        }
    }
    
    @ViewBuilder
    func buildCityScreen(cities: [CityLocationViewData], mapViewData: MapViewData?) -> some View {
        if deviceOrientation == .portrait {
            buildCityList(cities: cities)
        } else if let mapViewData = mapViewData {
            buildCityListWithMap(cities: cities, mapViewData: mapViewData)
        }
    }
    
    func buildCityListWithMap(cities: [CityLocationViewData], mapViewData: MapViewData) -> some View {
        HStack {
            buildCityList(cities: cities)
                .frame(width: 200)
            MapView(viewData: $mapViewData)
        }
    }
    
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        List {
            ForEach(cities) { city in
                CityCellView(city: city)
                    .listRowInsets(EdgeInsets())
                    
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
}
