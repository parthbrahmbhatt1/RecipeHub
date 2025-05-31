//
//  ImageCache.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/29/25.
//

import UIKit

actor ImageCache {
    static let shared = ImageCache()

    private let cacheDirectory: URL
    private var memoryCache: [URL: UIImage] = [:]

    private init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = caches.appendingPathComponent("RecipeImageCache")
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    private func cachePath(for url: URL) -> URL {
        let fileName = url.absoluteString + ".imgcache"
        return cacheDirectory.appendingPathComponent(fileName)
    }

    func image(for url: URL) async -> UIImage? {
        if let image = memoryCache[url] {
            return image
        }
        let path = cachePath(for: url)
        if let data = try? Data(contentsOf: path),
           let image = UIImage(data: data) {
            memoryCache[url] = image
            return image
        }
        return nil
    }

    func save(_ image: UIImage, for url: URL) async {
        memoryCache[url] = image
        let path = cachePath(for: url)
        if let data = image.pngData() {
            try? data.write(to: path)
        }
    }
}
