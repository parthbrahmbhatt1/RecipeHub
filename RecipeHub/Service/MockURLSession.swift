//
//  MockURLSession.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data!, response!)
    }
}
