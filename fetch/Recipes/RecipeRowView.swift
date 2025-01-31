//
//  RecipeRowView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/30/25.
//

import SwiftUI

struct RecipeRowView: View {
    @State private var largeImage: UIImage?
    
    let cuisine: String
    let largePhotoURL: String?
    let name: String
    let smallPhotoURL: String?
    
    var body: some View {
        Group {
            if let largeImage {
                DisclosureGroup {
                    Image(uiImage: largeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } label: {
                    RecipeLabelView(cuisine: cuisine, name: name, smallPhotoURL: smallPhotoURL)
                }
            } else {
                RecipeLabelView(cuisine: cuisine, name: name, smallPhotoURL: smallPhotoURL)
            }
        }
        .task {
            if let largePhotoURL {
                let fetchedLargeImage = await ImageFetcher.shared.fetchImage(for: largePhotoURL)
                largeImage = fetchedLargeImage
            }
        }
    }
}

#Preview("No images") {
    RecipeRowView(cuisine: "Malaysian",
                  largePhotoURL: nil,
                  name: "Apam Balik",
                  smallPhotoURL: nil)
}

#Preview("Small image, no large image") {
    RecipeRowView(cuisine: "Malaysian",
                  largePhotoURL: nil,
                  name: "Apam Balik",
                  smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
    .padding()
}

#Preview("Large image, no small image") {
    RecipeRowView(cuisine: "Malaysian",
                  largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                  name: "Apam Balik",
                  smallPhotoURL: nil)
    .padding()
}

#Preview("Both images") {
    RecipeRowView(cuisine: "Malaysian",
                  largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                  name: "Apam Balik",
                  smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
    .padding()
}
