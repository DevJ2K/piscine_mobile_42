//
//  ContentView.swift
//  weatherApp_proj
//
//  Created by Théo Ajavon on 28/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var lastSearch: String = ""
    @State private var searchText = ""
    @State private var showSearchBar = false
    @FocusState private var focusedSearch: Bool?
    @State private var selectedTab: Tab = .currently
    @Environment (\.colorScheme) var colorScheme
    
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
    
    func sendSearchLocation() -> Void {
        focusedSearch = false
        withAnimation(.easeInOut(duration: 0.2)) {
            showSearchBar = false
        }
        if (searchText.isEmpty) {
            searchText = lastSearch
        }
    }
    func cancelSearchLocation() -> Void {
        focusedSearch = false
        withAnimation(.easeInOut(duration: 0.2)) {
            showSearchBar = false
        }
        searchText = lastSearch
    }
    
    var body: some View {
        //        Text("Yooo")
        VStack {
            HStack {
                if (showSearchBar == false) {
                    Text(tabName)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    Spacer()
                }
                
                
                HStack {
                    if (showSearchBar) { // The search bar
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchText)
                            .focused($focusedSearch, equals: true)
                            .onSubmit {
                                sendSearchLocation()
                            }
                            .submitLabel(.search)
//                            .foregroundStyle(.blue, .red)
                        Button(action: {
                            if (searchText.isEmpty == false) {
                                searchText = ""
                            } else {
                                cancelSearchLocation()
                            }
                        }, label: {
                            if (searchText.isEmpty == false) {
                            
                                Image(systemName: "xmark")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                            } else {
                                Text("Cancel")
                                    .font(.subheadline)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                            }
                        })
                    } else {
                        
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    lastSearch = searchText
                                    searchText = ""
                                    showSearchBar = true
                                    focusedSearch = true
                                }
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .padding(10)
                            })
                            Button(action: {
                                searchText = "Geolocation"
                                lastSearch = searchText
                            }, label: {
                                Image(systemName: "location")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .padding(10)
                            })
                        }
                        
                        //                    .background(Color.white)
                        //                    .clipShape(Circle())
                    }
                }
                .padding(showSearchBar ? 10 : 0)
                .background(.thinMaterial)
                //            .clipShape(Circle())
                .cornerRadius(20)
            }
            .padding(.top, 15)
            .padding(.horizontal)
            .padding(.bottom, 8)
            //            .background(.ultraThinMaterial)
            
            TabView(selection: $selectedTab) {
                //            HStack {
                //                TextField("Search", text: $searchText)
                //                    .padding(8)
                //                    .background(Color.gray.opacity(0.2))
                //                    .cornerRadius(8)
                //            }
                CurrentlyView(searchLocation: searchText)
                    .navigationTitle("Currently")
                    .tabItem {
                        VStack {
                            Image(systemName: "sun.min")
                            Text("Currently")
                        }
                    }
                    .tag(Tab.currently)
                TodayView(searchLocation: searchText)
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar.day.timeline.left")
                            Text("Today")
                        }
                        
                    }
                    .tag(Tab.today)
                WeeklyView(searchLocation: searchText)
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
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onTapGesture {
            if (focusedSearch == true) {
                cancelSearchLocation()
            }
        }
//        .ignoresSafeArea(.all)
        .padding(.top)
//        .padding(.bottom)
        .background(colorScheme == .dark
                    ? LinearGradient(
                        gradient: Gradient(colors: [.purple.opacity(0.2), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    : LinearGradient(
                        gradient: Gradient(colors: [.purple.opacity(0.7), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
    }
    
    
}

#Preview {
    ContentView()
}
