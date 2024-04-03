//
//  City.swift
//  weatherAppV2proj
//
//  Created by Théo Ajavon on 01/04/2024.
//
//        https://geocoding-api.open-meteo.com/v1/search?name=&count=10&language=en&format=json

import Foundation


struct CityResult: Codable {
    var results: [City]
}

struct City: Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var elevation: Int
    var timezone: String?
    var country: String?
    var admin1: String? //  Région
}

struct CityInfo: Codable {
    var id: Int
    var latitude: Double
    var longitude: Double
    var elevation: Int
    

    var city: City
    
    // ALL TAB
    var name: String
    var admin1: String? //  Région
    var country: String?

    // CURRENT TAB
    var temperature: Int
    var currentWeather: String
    var windSpeed: Int
    
    // TODAY TAB
    var timezone: String?
    var temperatureByHours: [Dictionary<String, Int>]
    var weatherDescByHours: [Dictionary<String, String>]
    var windSpeedByHours: [Dictionary<String, Int>]

    // WEEKLY TAB
//    var weatherDateList: [Array<AnyObject>]
}

func fetchCityInfo(city: City) async -> CityInfo? {
    let currentTabUrlString = "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,is_day,weather_code,wind_speed_10m&timezone=Europe/Berlin"
    let todayTabUrlString = ""
    let weeklyTabUrlString = ""
    
    guard let currentTabUrl = URL(string: currentTabUrlString) else {
        print("This request has failed please try with an other URL...")
        return nil
    }
    return nil
}

func fetchCity(name: String) async -> [City] {
//    print("0")
    let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(name)&count=5&language=en&format=json"
    print(urlString)
    // Create URL
    guard let url = URL(string: urlString) else {
        print("This request has failed please try with an other URL...")
        return []
    }
    
    // Fetch data from the URL
    do {
//        print("1")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Invalid status code != 200")
            return []
        }
//        print("2")
        // decode the data
        let decodedResponse = try JSONDecoder().decode(CityResult.self, from: data)
//        print("3")
//        print(decodedResponse.results)
        return decodedResponse.results
    } catch {
        print("Failed to fetch the data : \(error)")
    }
    
//    print("4")
    return []
}
