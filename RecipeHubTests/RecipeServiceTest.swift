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
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        service = RecipeService(session: session)
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
        MockURLProtocol.testData = jsonString.data(using: .utf8)
        MockURLProtocol.responseCode = 200
        
        let url = URL(string: "https://dummy.url")!
        let recipes = try await service.getRecipes(from: url)
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes[0].name, "Bakewell Tart")
        XCTAssertEqual(recipes[0].cuisine, "British")
    }
    
    func testGetMalformedRecipes() async {
        let malformedJSON = """
        {
          "recipes": [
            {
              "cuisine": "British",
              "name": "Bakewell Tart"
              // Missing commas, fields, etc.
            }
          ]
        }
        """

        MockURLProtocol.testData = malformedJSON.data(using: .utf8)
        MockURLProtocol.responseCode = 200

        let url = URL(string: "https://inavlid.com")!

        do {
            _ = try await service.getRecipes(from: url)
            XCTFail("Expected malformedData error, but got success")
        } catch let error as RecipeServiceError {
            XCTAssertEqual(error, .malformedData)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

