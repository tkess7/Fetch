//
//  ImageFetcher.swift
//  fetch
//
//  Created by Travis Kessinger on 1/31/25.
//

import Foundation
import SwiftUI

class ImageFetcher {
    
    static let shared = ImageFetcher()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("URL for FileManager in .cachesDirectory directory was unavailable")
        }
        
        cacheDirectory = url
    }
    
    func fetchImage(for stringURL: String) async -> UIImage? {
        guard let url = URL(string: stringURL) else {
            return nil
        }
        
        guard let image = retrieveCachedImage(for: stringURL) else {
            do {
                let response = try await URLSession.shared.data(from: url)
                let imageData = response.0
                let image = UIImage(data: imageData)
                
                if let image {
                    updateCacheImage(with: image, for: stringURL)
                }
                
                return image
            } catch {
                return nil
            }
        }
        
        return image
    }
    
    private func retrieveCachedImage(for stringURL: String) -> UIImage? {
        let cacheFileURL = cacheFilePath(for: stringURL)
        
        if fileManager.fileExists(atPath: cacheFileURL.path),
           let pngImageData = try? Data(contentsOf: cacheFileURL),
           let image = UIImage(data: pngImageData) {
            return image
        }
        
        return nil
    }
    
    private func updateCacheImage(with image: UIImage, for stringURL: String) {
        guard let pngData = image.pngData() else {
            return
        }
        
        let cacheFileURL = cacheFilePath(for: stringURL)
        try? pngData.write(to: cacheFileURL)
    }
    
    private func cacheFilePath(for stringURL: String) -> URL {
        let percentEncodedURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(percentEncodedURL)
    }
}
