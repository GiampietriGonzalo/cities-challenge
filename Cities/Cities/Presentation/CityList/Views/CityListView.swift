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
    @State private var selectedCityId: Int?
    private var isSearching: Bool { !searchText.isEmpty }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                Text("Loading...")
                    .task { await viewModel.load() }
            case let .loaded(viewData):
                buildCityScreen(cities: viewData.cityLocations)
            case .onError(let error):
                Text("Error: \(error)")
            }
        }
        .onChange(of: viewModel.state) {
            guard case .loaded(let viewData) = viewModel.state,
                  let mapViewData = viewData.mapViewData else { return }
            self.mapViewData = mapViewData
        }
        .onRotate { newOrientation in
            deviceOrientation = newOrientation
        }
        .navigationTitle("Cities")
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    func buildCityScreen(cities: [CityLocationViewData]) -> some View {
        Group {
            if isSearching, cities.isEmpty {
                buildNoResultsView()
            } else if deviceOrientation.isLandscape {
                buildCityListWithMap(cities: cities)
            } else {
                buildCityList(cities: cities)
            }
        }
        .modifier(SearchViewModifier(searchText: $searchText, prompt: "Search by name"))
        .onChange(of: searchText) {
            guard case let .loaded(viewData) = viewModel.state else { return }
            viewData.onFilter(searchText)
        }
    }
    
    func buildNoResultsView() -> some View {
        ContentUnavailableView("City not found",
                               systemImage: "magnifyingglass",
                               description: Text("No results for **\(searchText)**"))
    }
        
    func buildCityListWithMap(cities: [CityLocationViewData]) -> some View {
        HStack(spacing: 0) {
            buildCityList(cities: cities)
                .frame(width: 250)
            MapView(viewData: $mapViewData)
        }
    }
    
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(cities) { cityViewData in
                    CityCellView(viewData: cityViewData)
                        .onTapGesture {
                            cityViewData.onSelect(deviceOrientation.isLandscape)
                            selectedCityId = cityViewData.id
                        }
                        .background(selectedCityId == cityViewData.id ? Color.gray.opacity(0.3) : Color.white)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .horizontal)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
    }
}
