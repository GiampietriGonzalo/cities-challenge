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
                    .navigationTitle("Cities")
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
        .onAppear {
            selectedCityId = nil
        }
        .toolbar(deviceOrientation.isLandscape ? .hidden : .automatic)
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    func buildCityScreen(cities: [CityLocationViewData]) -> some View {
        Group {
            if deviceOrientation.isLandscape {
                buildCityListWithMap(cities: cities)
            } else {
                buildCityList(cities: cities)
                    .modifier(SearchViewModifier(searchText: $searchText, prompt: "Search by name"))
            }
        }
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
        
    @ViewBuilder
    func buildCityListWithMap(cities: [CityLocationViewData]) -> some View {
        if isSearching, cities.isEmpty {
            buildNoResultsView()
        } else {
            HStack(spacing: 0) {
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .renderingMode(.template)
                                .padding(.vertical, 4)
                                .padding(.leading, 8)
                            TextField("Search by name", text: $searchText)
                                .textFieldStyle(.plain)
                                .padding(.vertical, 4)
                                .padding(.trailing, 8)
                        }
                        .frame(height: 32)
                        .background(Color.gray.opacity(0.1))
                        .foregroundStyle(.secondary)
                        .cornerRadius(8)
                        .padding(.horizontal, 24)
                    }
                    .ignoresSafeArea()
                    .padding(.top, 16)
                    
                    buildCityList(cities: cities)
                }
                .frame(width: 250)
                MapView(viewData: $mapViewData)
            }
        }
    }
    
    @ViewBuilder
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        if isSearching, cities.isEmpty {
            buildNoResultsView()
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(cities) { cityViewData in
                            CityCellView(viewData: cityViewData)
                                .onTapGesture {
                                    cityViewData.onSelect(deviceOrientation.isLandscape)
                                    selectedCityId = cityViewData.id
                                }
                                .background(selectedCityId == cityViewData.id ? Color.gray.opacity(0.3) : .clear)
                        }
                    }
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                        }
                    )
                }
                .ignoresSafeArea(.container, edges: .horizontal)
                .scrollIndicators(.hidden)
            }
        }
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    NavigationStack {
        CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
    }
}
