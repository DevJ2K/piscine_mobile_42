//
//  ContentView.swift
//  weatherAppV2proj
//
//  Created by Théo Ajavon on 29/03/2024.
//

import SwiftUI




struct ContentView: View {
    @State private var lastSearch: String = ""
    @State private var cities = [City]()
    @State private var searchCity: City?
    @State private var searchText = ""
    @State private var showSearchBar = true
    @FocusState private var focusedSearch: Bool?
    @State private var selectedTab: Tab = .currently
    @Environment (\.colorScheme) var colorScheme
    
    //    @StateObject private var locationManager = LocationManager()
    @ObservedObject var locationManager = LocationManager.shared
    
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
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        // Hide keyboard
        hideKeyboard()
        // Wait for the keyboard to hide before performing animation
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        withAnimation(.easeInOut(duration: 0.2)) {
            showSearchBar = false
        }
        searchText = lastSearch
        focusedSearch = false
        //        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // HEADER
            HStack {
                // TITLE
                if (showSearchBar == false) {
                    Text(tabName)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    Spacer()
                }
                
                // LOC SEARCH
                HStack {
                    if (showSearchBar) { // The search bar
                        Image(systemName: "magnifyingglass")
                        TextField("Search", text: $searchText)
                            .focused($focusedSearch, equals: true)
                            .onSubmit {
                                //                                sendSearchLocation()
                                hideKeyboard()
                            }
                            .onChange(of: searchText) { newValue in
                                if (searchText.isEmpty == false) {
                                    Task {
                                        
                                        cities = await fetchCity(name: searchText)
                                        print(searchText)
                                    }
                                } else {
                                    cities = []
                                }
                            }
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
                                    .bold()
                            })
                            Button(action: {
                                searchText = "Geolocation"
                                lastSearch = searchText
                                searchCity = LocationManager.shared.currentLocationCity
                                LocationManager.shared.requestLocation()
                            }, label: {
                                Image(systemName: "location")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .padding(10)
                                    .bold()
                            })
                        }
                    }
                }
                .padding(showSearchBar ? 10 : 0)
                .background(.thinMaterial)
                .cornerRadius(20)
            }
            .padding(.top, 15)
            .padding(.horizontal)
            .padding(.bottom, 12)
            .background(showSearchBar ? Color.primary.opacity(0.2) : Color.clear)
            
            
            if (showSearchBar) {
                List(cities, id: \.id) { city in
                    Button(action: {
                        print(city.id)
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "building.2")
                                .padding(.trailing, 16)
                            Text(city.name)
                                .bold()
                            if let region = city.admin1 {
                                Text(" \(region)")
                            }
                            if let country = city.country {
                                Text(", " + country)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                    .padding()
                }
            } else {
                TabView(selection: $selectedTab) {
                    CurrentlyView(searchLocation: locationManager.location != nil
                                  ? "\(locationManager.location!.latitude) \(locationManager.location!.longitude)"
                                  : "Geolocation is not available, please enable it in your App settings.")
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
        }
        .padding(.bottom, 20)
        .background(LinearGradient(
            gradient: Gradient(colors: [.purple.opacity(colorScheme == .dark ? 0.2 : 0.7), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea(edges: .bottom)
    }
    
    
}

#Preview {
    ContentView()
}
