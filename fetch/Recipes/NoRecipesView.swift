//
//  NoRecipesView.swift
//  fetch
//
//  Created by Travis Kessinger on 2/1/25.
//

import SwiftUI

struct NoRecipesView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("There are no recipes!")
                .font(.title3)
            Text("You can retrieve data again by pulling to refresh!")
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview {
    NoRecipesView()
}
