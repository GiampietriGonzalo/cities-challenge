import XCTest
@testable import Cities

final class NetworkRestClientTests: XCTestCase {

    private var sut: NetworkRestClient!
    private var url: URL = URL(string: "https://example.com")!
    
    struct MockResponse: Codable {
        let foo: String?
    }

    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)

        sut = NetworkRestClient()
        sut.configure(with: session)
    }
    

    func testFetchSuccess() async throws {
        let expected = ["foo": "bar"]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: expected) else {
            XCTFail()
            return
        }
        
        URLProtocolMock.testData = jsonData
        URLProtocolMock.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let result: MockResponse = try await sut.fetch(from: url)
        XCTAssert(result.foo == "bar")
    }
    

    func testFetchDecodeError() async throws {
        URLProtocolMock.testData = "invalidJson".data(using: .utf8)
        URLProtocolMock.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            let _: MockResponse = try await sut.fetch(from: url)
            XCTFail("Expected to throw")
        } catch CustomError.decodeError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected CustomError.decodeError")
        }
    }
    

    func testFetchNon200StatusCode() async throws {
        URLProtocolMock.testData = Data()
        URLProtocolMock.response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)

        do {
            let _: MockResponse = try await sut.fetch(from: url)
            XCTFail("Expected serviceError")
        } catch CustomError.serviceError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Expected serviceError")
        }
    }
}
