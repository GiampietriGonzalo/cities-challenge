//
//  NetworkClientMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 03/06/2025.
//

import Foundation

final class NetworkClientMock: NetworkClientProtocol {
    
    var dto: Decodable?
    var customError: CustomError = .serviceError("error")
    
    func fetch<T: Decodable>(from url: URL) async throws(CustomError) -> T {
        guard let dto = dto as? T else {
            throw customError
        }
        
        return dto
    }
}
