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

func fetchCity(name: String) async -> [City] {
    print("0")
    let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(name)&count=5&language=fr&format=json"
    print(urlString)
    // Create URL
    guard let url = URL(string: urlString) else {
        print("This request has failed please try with an other URL...")
        return []
    }
    
    // Fetch data from the URL
    do {
        print("1")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Invalid status code != 200")
            return []
        }
        print("2")
        // decode the data
        let decodedResponse = try JSONDecoder().decode(CityResult.self, from: data)
        print("3")
        print(decodedResponse.results)
        return decodedResponse.results
    } catch {
        print("Failed to fetch the data : \(error)")
    }
    
    print("4")
    return []
}
