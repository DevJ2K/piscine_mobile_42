//
//  CurrentlyView.swift
//  weatherAppV2proj
//
//  Created by Théo Ajavon on 29/03/2024.
//

import SwiftUI

struct CurrentlyView: View {
    var searchLocation: String
    
    var body: some View {
        VStack {
            Text("Currently")
                .font(.title)
                .bold()
            Text(searchLocation)
                .font(.title2)
        }
    }
}

#Preview {
    CurrentlyView(searchLocation: "Madrid")
}
