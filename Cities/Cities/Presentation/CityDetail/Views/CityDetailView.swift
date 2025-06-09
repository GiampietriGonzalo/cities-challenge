//
//  CityDetailView.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

import SwiftUI

struct CityDetailView<ViewModel: CityDetailViewModelProtocol>: View {
    
    let viewModel: ViewModel
    
    var body: some View {
            switch viewModel.state {
            case .loading:
                Text("Loading...")
                    .task { await viewModel.load() }
            case .loaded(let viewData):
                buildContent(with: viewData)
            case .onError(let error):
                ContentUnavailableView("Something went wrong",
                                       systemImage: "exclamationmark.triangle",
                                       description: Text("City information not available"))
            }
    }
    
    @ViewBuilder
    private func buildContent(with viewData: CityDetailViewData) -> some View {
        ScrollView {
            VStack {
                AsyncImage(url: viewData.image) { image in
                    image.image?
                        .resizable()
                }
                .frame(height: 250)
                .shadow(radius: 8)
                .cornerRadius(8)

                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                VStack {
                    Group {
                        HStack {
                            Text(viewData.subtitle)
                                .font(.title2)
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewData.description)
                                .font(.footnote)
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewData.extract)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    
                }
                .padding(.leading, 16)
                .padding(.top, 8)
                
                Spacer()
            }
            .navigationTitle(viewData.title)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NavigationStack {
        CityDetailView(viewModel: AppContainer.shared.buildCityDetailViewModel(cityName: "Buenos Aires", countryCode: "AR"))
    }
}
