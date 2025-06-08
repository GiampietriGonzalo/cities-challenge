//
//  CityListView.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI
import SwiftData

struct CityListView: View {
    
    var mapViewModel: MapViewModelProtocol?
    @State var viewModel: CityListViewModelProtocol
    @State private var deviceOrientation: UIDeviceOrientation = .unknown
    @State private var mapViewData: MapViewData = .empty
    @State private var searchText: String = ""
    private var isSearching: Bool { !searchText.isEmpty }
    
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
        }
        .overlay {
            if isSearching,
               case let .loaded(viewData) = viewModel.state,
               viewData.cityLocations.isEmpty {
                ContentUnavailableView("Product not available",
                                       systemImage: "magnifyingglass",
                                       description: Text("No results for **\(searchText)**")
                )
            }
        }
        .toolbar(deviceOrientation.isLandscape ? .hidden : .automatic)
        .navigationTitle("Cities")
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
            MapView(viewData: $mapViewData)
        }
    }
    
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        List {
            ForEach(cities) { cityViewData in
                CityCellView(viewData: cityViewData)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        cityViewData.onSelect(deviceOrientation.isLandscape)
                    }
                    
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search by city name")
        .textInputAutocapitalization(.never)
        .onChange(of: searchText) {
            guard case let .loaded(viewData) = viewModel.state else { return }
            debugPrint(searchText)
            viewData.onFilter(searchText)
        }
    }
}

#Preview {
    NavigationStack {
        CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
    }
}
