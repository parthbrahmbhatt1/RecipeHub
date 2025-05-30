//
//  ImageLoader.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//
import SwiftUI

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: URL
    private var task: Task<Void, Never>?

    init(url: URL) {
        self.url = url
    }

    func load() {
        guard task == nil else { return }
        task = Task {
            if let cachedImage = await DiskImageCache.shared.image(for: url) {
                self.image = cachedImage
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    self.image = uiImage
                    await DiskImageCache.shared.save(uiImage, for: url)
                }
            } catch {
                print("Error:", error)
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
