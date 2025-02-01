//
//  ImageFetcher.swift
//  fetch
//
//  Created by Travis Kessinger on 1/31/25.
//

import Foundation
import SwiftUI

actor ImageFetcher {
    
    static let shared = ImageFetcher()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let imageService: ImageRetrieving
    
    init(service: ImageRetrieving = ImageService()) {
        guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("URL for FileManager in .cachesDirectory directory was unavailable")
        }
        
        cacheDirectory = url
        imageService = service
    }
    
    func fetchImage(for stringURL: String, with path: String) async -> UIImage? {
        guard let image = retrieveCachedImage(for: path) else {
            do {
                let image = try await imageService.fetchImage(for: stringURL)
                
                if let image {
                    updateCacheImage(with: image, for: path)
                }
                
                return image
            } catch {
                return nil
            }
        }
        
        return image
    }
    
    func retrieveCachedImage(for path: String) -> UIImage? {
        let cacheFileURL = cacheFilePath(for: path)
        
        if fileManager.fileExists(atPath: cacheFileURL.path),
           let pngImageData = try? Data(contentsOf: cacheFileURL),
           let image = UIImage(data: pngImageData) {
            return image
        }
        
        return nil
    }
    
    private func updateCacheImage(with image: UIImage, for path: String) {
        guard let pngData = image.pngData() else {
            return
        }
        
        let cacheFileURL = cacheFilePath(for: path)
        
        // Optional try because if we are unable to save the data to cache,
        // the user will still be able to see the image from the source URL
        try? pngData.write(to: cacheFileURL)
    }
    
    private func cacheFilePath(for path: String) -> URL {
        guard let percentEncodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            fatalError("Unable to percent encode path \(path)")
        }
        
        return cacheDirectory.appendingPathComponent(percentEncodedPath)
    }
}
