//
//  TodayView.swift
//  weatherApp_proj
//
//  Created by Théo Ajavon on 28/03/2024.
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
