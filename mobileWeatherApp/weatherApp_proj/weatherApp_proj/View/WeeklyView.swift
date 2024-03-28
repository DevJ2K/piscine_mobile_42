//
//  WeeklyView.swift
//  weatherApp_proj
//
//  Created by Théo Ajavon on 28/03/2024.
//

import SwiftUI

struct WeeklyView: View {
    var searchLocation: String
    
    var body: some View {
        VStack {
            Text("Weekly")
                .font(.title)
                .bold()
            Text(searchLocation)
                .font(.title2)
        }
    }
}

#Preview {
    WeeklyView(searchLocation: "Paris")
}
