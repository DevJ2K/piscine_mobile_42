//
//  TodayView.swift
//  weatherAppV2proj
//
//  Created by Théo Ajavon on 29/03/2024.
//

import SwiftUI

struct TodayView: View {
    var searchLocation: String
    
    var body: some View {
        VStack {
            Text("Today")
                .font(.title)
                .bold()
            Text(searchLocation)
                .font(.title2)
        }
    }
}

#Preview {
    TodayView(searchLocation: "Montréal")
}
