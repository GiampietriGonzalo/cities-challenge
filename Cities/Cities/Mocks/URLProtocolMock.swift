//
//  URLProtocolMock.swift
//  Cities
//
//  Created by Gonza Giampietri on 13/06/2025.
//
import Foundation

final class URLProtocolMock: URLProtocol {
    static var testData: Data?
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override func startLoading() {
        if let error = URLProtocolMock.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = URLProtocolMock.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = URLProtocolMock.testData {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {}
    
    static func reset() {
        testData = nil
        response = nil
        error = nil
    }
}
