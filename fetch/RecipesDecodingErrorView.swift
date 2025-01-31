//
//  RecipesDecodingErrorView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/31/25.
//

import SwiftUI

struct RecipesDecodingErrorView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Oh no! Something went wrong with our recipes! We are hard at working attempting to cook up a fix.")
                .font(.title3)
            Text("You can try again by pulling to refresh!")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    RecipesDecodingErrorView()
}
