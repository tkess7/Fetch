//
//  ImageRetrieving.swift
//  fetch
//
//  Created by Travis Kessinger on 2/1/25.
//

import Foundation
import SwiftUI

protocol ImageRetrieving {
    func fetchImage(for stringURL: String) async throws -> UIImage?
}

struct ImageService: ImageRetrieving {
    func fetchImage(for stringURL: String) async throws -> UIImage? {
        guard let url = URL(string: stringURL) else {
            throw ImageServierError.invalidURL
        }
        
        let response = try await URLSession.shared.data(from: url)
        let imageData = response.0
        let image = UIImage(data: imageData)
        return image
    }
}

enum ImageServierError: Error {
    case invalidURL
}
