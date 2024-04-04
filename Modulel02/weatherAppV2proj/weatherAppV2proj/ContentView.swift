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
    @State private var searchText = ""
    @State private var showSearchBar = false
    @FocusState private var focusedSearch: Bool?
    @State private var selectedTab: Tab = .currently
    @Environment (\.colorScheme) var colorScheme
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
    
    func cancelSearchLocation() -> Void {
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
                                locationManager.requestLocation()
                                if (locationManager.cityLocation != nil) {
                                    Task {
                                        locationManager.cityInfo = await fetchCityInfo(city: locationManager.cityLocation!)
//                                        await print(fetchCityInfo(city: locationManager.cityLocation!) ?? "Empty")
                                    }
                                }

                                
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
            .background(showSearchBar ? Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.25) : Color.clear)
            
            
            if (showSearchBar) {
                //                if (searchText.isEmpty && searchText.count == 1) {
                //                    VStack {
                //                    }
                //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                    .background(colorScheme == .dark ? .black : .white)
                //                    .ignoresSafeArea(.all)
                //                } else if (cities.count == 0 && searchText.count < 1) {
                //                    VStack(spacing: 12) {
                //                        Spacer()
                //                        Image(systemName: "magnifyingglass")
                //                            .foregroundStyle(.gray)
                //                            .font(.system(size: 48))
                //                        VStack(spacing: 2) {
                //                            Text("**No Results**")
                //                                .font(.title2)
                //                            Text("No results found for \"\(searchText)\".")
                //                                .foregroundStyle(.gray)
                //                                .font(.subheadline)
                //                        }
                //                        Spacer()
                //                    }
                //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                    .background(colorScheme == .dark ? .black : .white)
                //                } else {
                List(cities, id: \.id) { city in
                    Button(action: {
                        print("\(city.id) : \(city.longitude) | \(city.latitude)")
                        searchText = ""
                        Task {
                            await locationManager.updateCity(city: city)
                            print(locationManager.cityInfo ?? "City Info Empty !")
                        }
                        focusedSearch = false
                        hideKeyboard()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearchBar = false
                        }
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "building.2")
                                .padding(.trailing, 16)
                            Text("**\(city.name)**")
                            + Text((city.admin1 != nil) ? " \(city.admin1!)" : "")
                            + Text((city.country != nil) ? ", \(city.country!)" : "")
                            
                        }
                    }
                    .foregroundStyle(.primary)
                }
                //                }
            } else {
                TabView(selection: $selectedTab) {
                    CurrentlyView(cityInfo: locationManager.cityInfo)
                    .navigationTitle("Currently")
                    .tabItem {
                        VStack {
                            Image(systemName: "sun.min")
                            Text("Currently")
                            
                        }
                    }
                    .tag(Tab.currently)
                    TodayView(cityInfo: locationManager.cityInfo)
                        .tabItem {
                            VStack {
                                Image(systemName: "calendar.day.timeline.left")
                                Text("Today")
                            }
                        }
                        .tag(Tab.today)
                    WeeklyView(cityInfo: locationManager.cityInfo)
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
//                .overlay(alignment: .bottom) {
//                    MyAppBar(selectedTab: $selectedTab)
//                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            MyAppBar(selectedTab: $selectedTab)
        }
        .padding(.bottom, 20)
        .background(showSearchBar ?
                    LinearGradient(colors: [colorScheme == .dark ? .black : .white], startPoint: .center, endPoint: .center) :
                        LinearGradient(
                            gradient: Gradient(colors: [.purple.opacity(colorScheme == .dark ? 0.2 : 0.7), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
