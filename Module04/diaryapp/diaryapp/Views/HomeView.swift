//
//  HomeView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 17/04/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
            VStack {
                Text("You are logged !")
                    .font(Font.custom("SignPainter", size: 42))
                    .padding()
                Button("Logout", action: UserManager.shared.logout)
                    .font(Font.custom("SignPainter", size: 28))
                    .padding()
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
            Spacer()
            
        }
    }
}

#Preview {
    ContentView()
//    HomeView()
}
