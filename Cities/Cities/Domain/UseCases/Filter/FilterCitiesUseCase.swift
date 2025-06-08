//
//  FilterCitiesUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FilterCitiesUseCase: FilterCitiesUseCaseProtocol {
    private let trie = CityTrie()
    private var isBuilt = false
    
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation] {
        guard !text.isEmpty else { return cities }
        let prefix = text.lowercased()
        
        if !isBuilt {
            for city in cities { trie.insert(city: city) }
            isBuilt = true
        }
        
        return trie.search(prefix: prefix)
    }
}

// MARK: - Trie Structure

struct CityTrie {
    private class Node {
        var children: [Character: Node] = [:]
        var cities: [CityLocation] = []
    }
    
    private let root = Node()
    
    func insert(city: CityLocation) {
        var current = root
        for char in city.name.lowercased() {
            if current.children[char] == nil {
                current.children[char] = Node()
            }
            
            if let children = current.children[char] {
                current = children
                current.cities.append(city)
            }
        }
    }
    
    func search(prefix: String) -> [CityLocation] {
        var current = root
        for char in prefix {
            guard let node = current.children[char] else {
                return []
            }
            current = node
        }
        return current.cities
    }
}
