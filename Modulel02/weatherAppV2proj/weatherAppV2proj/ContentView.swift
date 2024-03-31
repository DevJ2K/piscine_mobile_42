//
//  ContentView.swift
//  weatherAppV2proj
//
//  Created by Théo Ajavon on 29/03/2024.
//

import SwiftUI
import CoreLocation
import CoreLocationUI


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var location: CLLocationCoordinate2D?
    @Published var location: CLLocationCoordinate2D?
    
    static let shared = LocationManager()

    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // Requests the one-time delivery of the user’s current location.
//    func requestAllowOnceLocationPermission() {
//        locationManager.requestLocation()
//    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG : Not determined")
        case .restricted:
            print("DEBUG : Restricted")
        case .denied:
            print("DEBUG : Denied")
        case .authorizedAlways:
            print("DEBUG : Auth always")
        case .authorizedWhenInUse:
            print("DEBUG : Auth when in use")
        case .authorized:
            print("DEBUG : One time")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("HERE !")
        guard let latestLocation = locations.first else { return }
        self.location = latestLocation.coordinate
        locationManager.stopUpdatingLocation()
        print(self.location ?? "Empty")
        
//        DispatchQueue.main.async {
//            self.location = latestLocation.coordinate
//            print(self.location ?? "Empty")
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error of location : \(error.localizedDescription)")
    }
}

struct ContentView: View {
    @State private var lastSearch: String = ""
    @State private var searchText = ""
    @State private var showSearchBar = false
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
        ZStack {
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
                                        .bold()
                                })
//                                LocationButton(.currentLocation) {
//                                    print("Get my location")
//                                }
//                                .foregroundStyle(colorScheme == .dark ? .white : .black)
//                                .labelStyle(.iconOnly)
//                                .bold(false)
//                                .background(.yellow)
                                
                                Button(action: {
                                    searchText = "Geolocation"
                                    lastSearch = searchText
                                    LocationManager.shared.requestLocation()
                                }, label: {
                                    Image(systemName: "location")
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        .padding(10)
                                        .bold()
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
                    CurrentlyView(searchLocation: locationManager.location != nil
                                  ? "\(locationManager.location!.latitude) \(locationManager.location!.longitude)"
                                  : "undefined")
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
//            .ignoresSafeArea(.all)
//            .padding()
//            .padding(.top, 60)
            .padding(.bottom, 20)
            .background(colorScheme == .dark
                        ? LinearGradient(
                            gradient: Gradient(colors: [.purple.opacity(0.2), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                        : LinearGradient(
                        gradient: Gradient(colors: [.purple.opacity(0.7), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
        }
        .ignoresSafeArea(.keyboard)
//        .padding()
//        .scaledToFill()
    }
    
    
}

#Preview {
    ContentView()
}
