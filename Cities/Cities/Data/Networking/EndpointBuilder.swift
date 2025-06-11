//
//  EndpointBuilder.swift
//  Cities
//
//  Created by Gonza Giampietri on 09/06/2025.
//

import Foundation

struct EndpointBuilder {
    
    /**
     *  An enumeration that contains all the possible endpoints of the app
     */
    enum Endpoint {
        case cities
        case detail(name: String)
    }
    
    /**
     *  Builds and returns an URL for a given **Endpoint** value
     *  - Parameter endpoint: a given **Endpoint** value to build the URL
     *  - Returns: An URL
     */
    static func build(for endpoint: Endpoint) -> URL? {
        switch endpoint {
        case .cities:
            let url = BaseURL.cityLocations.rawValue.appending("dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")
            return URL(string: url)
        case .detail(let name):
            let formattedName = name.replacingOccurrences(of: " ", with: "_")
            let url = BaseURL.cityDetail.rawValue.appending(formattedName)
            return URL(string: url)
        }
    }
}
