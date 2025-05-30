//
//  Constants.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import Foundation

struct APIConstants {
    static let baseURLString = "https://d3jbb8n5wk0qxi.cloudfront.net"

    struct Endpoints {
        static let allRecipes = URL(string: "\(APIConstants.baseURLString)/recipes.json")!
        static let malformedData = URL(string: "\(APIConstants.baseURLString)/recipes-malformed.json")!
        static let emptyData = URL(string: "\(APIConstants.baseURLString)/recipes-empty.json")!
    }
}
