//
//  CityListView.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI
import SwiftData

struct CityListView: View {
    
    //MARK: Observed Dependencies
    @State var viewModel: CityListViewModelProtocol
    
    //MARK: Observed properties
    @State private var deviceOrientation: UIDeviceOrientation = .unknown
    @State private var mapViewData: MapViewData = .empty
    @State private var searchText: String = ""
    @State private var selectedCityId: Int?
    @State private var showCancelButton = false
    @State private var showAbout = false
    
    //MARK: Computable properties
    private var isSearching: Bool { !searchText.isEmpty }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                LoadingView()
                    .task { await viewModel.load() }
            case let .loaded(viewData):
                buildCityScreen(cities: viewData.cityLocations)
                    .navigationTitle(Strings.CitList.title)
            case .onError(let error):
                switch error {
                case let .invalidUrl(message),
                    let .serviceError(message),
                    let .decodeError(message):
                    ServiceErrorView(message: message, action: {
                        Task { await viewModel.load() }
                    })
                }
            }
        }
        .onChange(of: viewModel.state) {
            guard case .loaded(let viewData) = viewModel.state,
                  let mapViewData = viewData.mapViewData else { return }
            withAnimation {
                self.mapViewData = mapViewData
            }
        }
        .onRotate { newOrientation in
            deviceOrientation = newOrientation
        }
        .onAppear {
            selectedCityId = nil
        }
        .onShake {
            showAbout = true
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
                .presentationDetents([.medium])
        }
        .toolbar(deviceOrientation.isLandscape ? .hidden : .automatic)
        .ignoresSafeArea(.keyboard)
        .blur(radius: showAbout ? 4 : 0)
    }
}

//MARK: View Builders
private extension CityListView {
   
    @ViewBuilder
    func buildCityScreen(cities: [CityLocationViewData]) -> some View {
        Group {
            if deviceOrientation.isLandscape {
                buildCityListWithMap(cities: cities)
            } else {
                SearchBarView(searchText: $searchText, showCancelButton: $showCancelButton)
                buildCityList(cities: cities)
            }
        }
        .onChange(of: searchText) {
            guard case let .loaded(viewData) = viewModel.state else { return }
            viewData.onFilterPublisher.send(searchText)
        }
    }

    @ViewBuilder
    func buildCityListWithMap(cities: [CityLocationViewData]) -> some View {
        HStack(spacing: 0) {
            VStack {
                SearchBarView(searchText: $searchText, showCancelButton: $showCancelButton)
                    .ignoresSafeArea()
                    .padding(.top, 16)
                
                buildCityList(cities: cities)
            }
            .frame(width: 250)
            
            MapView(viewData: $mapViewData)
        }
    }
    
    @ViewBuilder
    func buildCityList(cities: [CityLocationViewData]) -> some View {
        if isSearching, cities.isEmpty {
            NoResultsErrorView(message: searchText)
                .ignoresSafeArea()
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(cities) { cityViewData in
                            CityCellView(viewData: cityViewData)
                                .onTapGesture {
                                    cityViewData.actionsPublisher.send(.select(id: cityViewData.id,
                                                                               orientationIsLandscape: deviceOrientation.isLandscape))
                                    selectedCityId = cityViewData.id
                                }
                                .background(selectedCityId == cityViewData.id ? Color.gray.opacity(0.3) : .clear)
                        }
                    }
                }
                .ignoresSafeArea(.container, edges: .horizontal)
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
    }
}
