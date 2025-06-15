//
//  FilterCitiesUseCase.swift
//  Cities
//
//  Created by Gonza Giampietri on 08/06/2025.
//

final class FilterCitiesUseCase: FilterCitiesUseCaseProtocol {
    private let trie = CityTrie()
    
    func setup(with cities: [CityLocation]) {
        for city in cities { trie.insert(city: city) }
    }
    
    func execute(cities: [CityLocation], filterBy text: String) -> [CityLocation] {
        guard !text.isEmpty else { return cities }
        return trie.search(prefix: text)
    }
}

// MARK: - Trie Structure
/**
 * Node: Each node in the Trie represents a character in a string (e.g., "s", "a", "l"), and paths through the tree represent words or names (e.g., "sal" → "Salta").
 *      Each node stores:
 *          - Its children (a dictionary [Character: Node])
 *          - An array of matching CityLocation entries at that path
 *
 */
struct CityTrie {
    class Node {
        var children: [Character: Node] = [:]
        var cities: [CityLocation] = []
    }
    
    let root = Node()
    
    /**
     * Traverses the characters in the city’s name + city's country code. At each character, it adds a new node (if it not exists) and appends the city to the cities list at that level
     */
    func insert(city: CityLocation) {
        var current = root
        let cityText = city.name + ", " + city.country
        
        for char in cityText {
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
    func search(prefix: String) -> [CityLocation] {
        var current = root
        for char in prefix {
            guard let node = current.children[char] else { return [] }
            current = node
        }
        return current.cities
    }
}
