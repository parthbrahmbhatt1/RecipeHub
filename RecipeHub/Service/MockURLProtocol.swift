//
//  MockURLProtocol.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var testData: Data?
    static var responseCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: MockURLProtocol.responseCode,
            httpVersion: nil,
            headerFields: nil)!

        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = MockURLProtocol.testData {
            client.urlProtocol(self, didLoad: data)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
