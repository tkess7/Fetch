//
//  RecipesGeneralErrorView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/31/25.
//

import SwiftUI

struct RecipesGeneralErrorView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Uh oh! There was an unexpected error.")
                .font(.title3)
            Text("You can try again by pulling to refresh!")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    RecipesGeneralErrorView()
}
