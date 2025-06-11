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
/**
 * Node: Each node in the Trie represents a character in a string (e.g., "a", "l", "b"), and paths through the tree represent words or names (e.g., "alb" → "alabama").
 *      Each node stores:
 *          - Its children (a dictionary [Character: Node])
 *          - An array of matching CityLocationViewData entries at that path
 *
 */
struct CityTrie {
    private class Node {
        var children: [Character: Node] = [:]
        var cities: [CityLocationViewData] = []
    }
    
    private let root = Node()
    
    /**
     * Traverses the characters in the city’s name. At each character, it adds a new node (if it not exists) and appends the city to the cities list at that level
     */
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
    
    /**
     * The trie walks down nodes matching the prefix parameter. If the path exists, it returns the cities stored at that node.
     */
    func search(prefix: String) -> [CityLocationViewData] {
        var current = root
        for char in prefix {
            guard let node = current.children[char] else { return [] }
            current = node
        }
        return current.cities
    }
}
