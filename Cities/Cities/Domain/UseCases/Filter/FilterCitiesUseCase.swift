//
//  FilterCitiesUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FilterCitiesUseCase: FilterCitiesUseCaseProtocol {
    private let trie = CityTrie()
    
    func setup(with cities: [CityLocationViewData]) {
        for city in cities { trie.insert(city: city) }
    }
    
    func execute(cities: [CityLocationViewData], filterBy text: String) -> [CityLocationViewData] {
        guard !text.isEmpty else { return cities }
        let prefix = text.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        
        return trie.search(prefix: prefix)
    }
}

// MARK: - Trie Structure

struct CityTrie {
    private class Node {
        var children: [Character: Node] = [:]
        var cities: [CityLocationViewData] = []
    }
    
    private let root = Node()
    
    func insert(city: CityLocationViewData) {
        var current = root
        for char in city.title.lowercased() {
            if current.children[char] == nil {
                current.children[char] = Node()
            }
            
            if let children = current.children[char] {
                current = children
                current.cities.append(city)
            }
        }
    }
    
    func search(prefix: String) -> [CityLocationViewData] {
        var current = root
        for char in prefix {
            guard let node = current.children[char] else { return [] }
            current = node
        }
        return current.cities
    }
}
