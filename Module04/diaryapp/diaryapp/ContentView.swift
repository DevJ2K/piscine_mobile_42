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
            
            
            if user.isAuthenticated {
                VStack {
                    Spacer()
                    VStack {
                        Text("You are logged !")
                        Button("Logout", action: user.logout)
                            .background(.red)
                            .padding()
                    }
                    .padding()
                    Spacer()
                    
                }
            } else {
                VStack {
                    Spacer()
                    LoginView()
                        .padding()
                    Spacer()
                    //                        Button("Login", action: self.login)
                }
            }
        }
        .background(
            LinearGradient(colors: [.purple, .white], startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        
        //        VStack {
        //            Image(systemName: "globe")
        //                .imageScale(.large)
        //                .foregroundStyle(.tint)
        //            Text("Hello, world!")
        //        }
        //        .padding()
    }
}

#Preview {
    ContentView()
}
