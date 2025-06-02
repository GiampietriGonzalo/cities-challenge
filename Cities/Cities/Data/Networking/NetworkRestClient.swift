//
//  NetworkRestClient.swift
//  Cities
//
//  Created by Gonza Giampietri on 02/06/2025.
//

import Foundation

/**
 *  Handle Rest networking calls
 * - Parameter url: The endpoint to perform the service call
 * - Returns: A Decodable instance
 * - Throws: **CustomError.serviceError:** when the service response status is not OK.  **CustomError.decodeError:**  when It is not possible to decode the response. **CustomError.networkError:** When there is another error with the service call
 */
final class NetworkRestClient: NetworkClientProtocol {
    private var session = URLSession(configuration: .default)
        
    func configure(with configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    func fetch<T: Decodable>(from url: URL) async throws(CustomError) -> T {
        var dto: T
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw CustomError.serviceError(url.absoluteString)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            dto = try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            debugPrint(error)
            throw CustomError.decodeError(url.absoluteString)
        } catch {
            throw CustomError.networkError(url.absoluteString)
        }
        
        return dto
    }
}

