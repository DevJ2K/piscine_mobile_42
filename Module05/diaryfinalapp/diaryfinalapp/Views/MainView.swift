//
//  MainView.swift
//  diaryapp
//
//  Created by Théo Ajavon on 18/04/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                }
        }
        .onAppear() {
            print("Init fetch entries !")
            self.dataManager.fetchEntries()
        }
    }
}

#Preview {
    MainView()
}
