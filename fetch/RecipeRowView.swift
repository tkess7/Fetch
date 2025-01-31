//
//  RecipeRowView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/30/25.
//

import SwiftUI

struct RecipeRowView: View {
    let cuisine: String
    let name: String
    let smallPhotoURL: String?
    
    var body: some View {
        HStack(spacing: 24) {
            if let smallPhotoURL {
                AsyncImage(url: URL(string: smallPhotoURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                } placeholder: {
                    ProgressView()
                        .frame(width: 48, height: 48)
                }

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
            
            Spacer()
        }
        .padding(16)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
}

#Preview("No recipe image") {
    RecipeRowView(cuisine: "Malaysian", name: "Apam Balik", smallPhotoURL: nil)
}

#Preview("Recipe with image") {
    RecipeRowView(cuisine: "Malaysian", name: "Apam Balik", smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
}
