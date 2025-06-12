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
                Text("Loading...")
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
                buildCityList(cities: cities)
                    .modifier(SearchViewModifier(searchText: $searchText,
                                                 prompt: Strings.CitList.searchPlaceholder))
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
                HStack {
                    buildLandingSearchBar()
                    
                    if showCancelButton {
                        buildCancelButton()
                            .padding(.trailing, 8)
                            .transition(.scale)
                    }
                }
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
    
    @ViewBuilder
    func buildLandingSearchBar() -> some View {
        HStack {
            Image(systemName: Strings.CitList.icons.search)
                .renderingMode(.template)
                .padding(.vertical, 4)
                .padding(.leading, 8)
            TextField(Strings.CitList.searchPlaceholder, text: $searchText, onEditingChanged: { editing in
                withAnimation {
                    showCancelButton = editing
                }
            })
            .textFieldStyle(.plain)
            .padding(.vertical, 4)
            .padding(.trailing, 8)
            .autocorrectionDisabled()
        }
        .frame(height: 32)
        .background(Color.gray.opacity(0.1))
        .foregroundStyle(.secondary)
        .cornerRadius(8)
        .padding(.leading, 24)
        .padding(.trailing, !showCancelButton ? 24 : 4)
    }
    
    @ViewBuilder
    func buildCancelButton() -> some View {
        Button {
            searchText = ""
        } label: {
            Text(Strings.CitList.cancelButtonText)
        }
    }
}

#Preview {
    NavigationStack {
        CityListView(viewModel: AppContainer.shared.buildCityListViewModel())
    }
}
