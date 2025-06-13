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
                LoadingView()
                    .task { await viewModel.load() }
                    .accessibilityIdentifier("LoadingView")
            case .loaded(let viewData):
                buildContent(with: viewData)
                    .accessibilityIdentifier("ContentView")
            case .onError:
                ContentUnavailableView("Something went wrong",
                                       systemImage: "exclamationmark.triangle",
                                       description: Text("City information not available"))
                .accessibilityIdentifier("ErrorView")
            }
    }
    
    @ViewBuilder
    private func buildContent(with viewData: CityDetailViewData) -> some View {
        ScrollView {
            VStack {
                AsyncImage(url: viewData.image) { phase in
                    Group {
                        if let image = phase.image {
                            image
                                .resizable()
                                .clipped()
                                .cornerRadius(8)
                                .shadow(radius: 8)
                        } else if phase.error != nil {
                            ContentUnavailableView("Image not available",
                                                   systemImage: "photo.badge.exclamationmark.fill")
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(height: 250)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }
                
                VStack {
                    Group {
                        HStack {
                            Text(viewData.subtitle)
                                .font(.title2)
                                .accessibilityIdentifier("Subtitle")
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewData.description)
                                .font(.caption)
                                .accessibilityIdentifier("Description")
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewData.extract)
                                .accessibilityIdentifier("Extract")
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
