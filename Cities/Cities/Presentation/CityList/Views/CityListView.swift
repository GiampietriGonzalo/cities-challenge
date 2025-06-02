//
//  CityListView.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI

struct CityListView: View {
    
    enum State {
        case loading
        case loaded([CityLocation])
        case onError(CustomError)
    }
    
    let viewModel: CityListViewModelProtocol
    
    var body: some View {
        switch viewModel.viewData.state {
        case .loading:
            Text("Loading...")
                .task {
                    viewModel.load()
                }
        case .loaded(let cities):
            buildCityList(cities: cities)
        case .onError(let error):
            Text("Error: \(error)")
        }
    }
    
    @ViewBuilder
    func buildCityList(cities: [CityLocation]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(cities) { city in
                    CityCellView(city: city)
                    Divider()
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("title")
    }
}

#Preview {
    CityListView(viewModel: AppContainer().buildCityListViewModel())
}
