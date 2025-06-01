//
//  CustomError.swift
//  Cities
//
//  Created by Gonza Giampietri on 01/06/2025.
//

enum CustomError: Error, Equatable {
    case invalidUrl(String)
    case serviceError(String)
    case networkError(String)
    case decodeError(String)
    case unknown
}
