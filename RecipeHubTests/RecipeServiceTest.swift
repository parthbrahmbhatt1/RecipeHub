//
//  RecipeServiceTest.swift
//  RecipeHubTests
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import XCTest
@testable import RecipeHub

final class RecipeServiceTests: XCTestCase {
    var service: RecipeService!
    var mockSession: MockURLSession!
    let validURL = APIConstants.baseURLString
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
    }
    
    func testGetValidRecipes() async throws {
        let jsonString = """
            {
              "recipes": [
                {
                  "cuisine": "British",
                  "name": "Bakewell Tart",
                  "photo_url_large": "https://some.url/large.jpg",
                  "photo_url_small": "https://some.url/small.jpg",
                  "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                  "source_url": "https://some.url/index.html",
                  "youtube_url": "https://www.youtube.com/watch?v=some.id"
                }
              ]
            }
            """
        mockSession.data = jsonString.data(using: .utf8)
        if let url = URL(string: APIConstants.baseURLString) {
            mockSession.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        }
        let service = RecipeService(session: mockSession)
        if let url = URL(string: APIConstants.baseURLString) {
            let recipes = try await service.getRecipes(from: url)
            XCTAssertEqual(recipes.count, 1)
            XCTAssertEqual(recipes[0].name, "Bakewell Tart")
            XCTAssertEqual(recipes[0].cuisine, "British")
        }
    }
}

