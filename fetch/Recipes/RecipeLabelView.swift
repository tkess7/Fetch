//
//  RecipeLabelView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/31/25.
//

import SwiftUI

struct RecipeLabelView: View {
    @State private var smallImage: UIImage?
    
    let cuisine: String
    let name: String
    let smallPhotoURL: String?
    let uuid: String
    
    var body: some View {
        HStack(spacing: 24) {
            if let smallImage {
                Image(uiImage: smallImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            } else {
                Image(systemName: "camera.metering.unknown")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.headline)
                Text(cuisine)
                    .font(.subheadline)
            }
        }
        .task {
            if let smallPhotoURL {
                let fetchedImage = await ImageFetcher.shared.fetchImage(for: smallPhotoURL, with: uuid)
                smallImage = fetchedImage
            }
        }
    }
}

#Preview {
    RecipeLabelView(cuisine: "Malaysian", name: "Apam Balik", smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: UUID().uuidString)
}
