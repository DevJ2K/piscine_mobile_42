//
//  ContentView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import SwiftUI
import Auth0

struct ContentView: View {
    @ObservedObject var user = UserManager.shared
    var body: some View {
        ZStack {
            
            
            if user.isAuthenticated == true {
                MainView()
            } else {
                LoginView()
            }
        }
        .background(
            LinearGradient(colors: [.purple, .white], startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
