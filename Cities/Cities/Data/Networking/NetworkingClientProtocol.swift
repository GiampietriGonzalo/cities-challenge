//
//  NetworkingClientProtocol.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//
import Foundation

/**
 *  Handle networking calls
 * - Parameter url: The endpoint to perform the service call
 * - Returns: A Decodable instance
 * - Throws: An error if something goes wrong
 */
protocol NetworkingClientProtocol {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}
