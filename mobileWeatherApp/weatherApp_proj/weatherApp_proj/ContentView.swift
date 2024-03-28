//
//  ContentView.swift
//  weatherApp_proj
//
//  Created by Théo Ajavon on 28/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var showSearchBar = false
    @State private var selectedTab: Tab = .currently
    
    private var tabName: String {
        switch selectedTab {
        case .currently:
            return "Currently"
        case .today:
            return "Today"
        case .weekly:
            return "Weekly"
        }
    }
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        //        Text("Yooo")
        HStack {
            if (showSearchBar == false) {
                Text(tabName)
                    .fontWeight(.bold)
                    .font(.title)
                Spacer()
            }
            //                .foregroundStyle(.white)
            
            
            HStack {
                if (showSearchBar) {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showSearchBar = false
                        }
                    }, label: {
                        Image(systemName: "xmark").foregroundStyle(.black)
                    })
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            searchText = ""
                            showSearchBar = true
                        }
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.black)
                            .padding(10)
                    })
//                    .background(Color.white)
//                    .clipShape(Circle())
                }
            }
            .padding(showSearchBar ? 10 : 0)
            .background(Color.white)
//            .clipShape(Circle())
            .cornerRadius(20)
        }
        //        .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color.purple)
        
        TabView(selection: $selectedTab) {
            //            HStack {
            //                TextField("Search", text: $searchText)
            //                    .padding(8)
            //                    .background(Color.gray.opacity(0.2))
            //                    .cornerRadius(8)
            //            }
            CurrentlyView()
                .navigationTitle("Currently")
                .tabItem {
                    VStack {
                        Image(systemName: "sun.min")
                        Text("Currently")
                    }
                }
                .tag(Tab.currently)
            TodayView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar.day.timeline.left")
                        Text("Today")
                    }
                    
                }
                .tag(Tab.today)
            WeeklyView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Weekly")
                    }
                }
                .tag(Tab.weekly)
        }
        .animation(nil, value: selectedTab)
        .searchable(text: $searchText)
        .overlay(alignment: .bottom) {
            MyAppBar(selectedTab: $selectedTab)
        }
        //        .tabViewStyle(.page)
        .tabViewStyle(.page(indexDisplayMode: .never))
//        .edgesIgnoringSafeArea(.top)
        //        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        //        .accentColor(.purple)
    }
   
    
}

#Preview {
    ContentView()
}
