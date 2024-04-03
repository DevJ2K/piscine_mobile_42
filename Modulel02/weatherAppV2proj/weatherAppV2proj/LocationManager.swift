//
//  LocationManager.swift
//  weatherAppV2proj
//
//  Created by Théo Ajavon on 01/04/2024.
//

import Foundation
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    //    @Published var location: CLLocationCoordinate2D?
    @Published var location: CLLocationCoordinate2D?
    @Published var currentLocationCity: City?
    private var userLocStatus: CLAuthorizationStatus?
    
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
        if (userLocStatus != nil) {
            if (userLocStatus == .authorizedWhenInUse || userLocStatus == .authorizedAlways) {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        userLocStatus = status
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
        print("STARTING FILL USER LOCATION !")
        guard let latestLocation = locations.first else { return }
        locationManager.stopUpdatingLocation()
        
        
        self.location = latestLocation.coordinate
        
        
        self.currentLocationCity = City(id: 1, name: "My Location", latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        
        
        getPlace(for: latestLocation) { placemark in
            guard let placemark = placemark else { return }
            if let cityName = placemark.locality {
                self.currentLocationCity?.name = cityName
            }
            
            if let country = placemark.country {
                self.currentLocationCity?.country = country
            }
            
            if let state = placemark.administrativeArea {
                self.currentLocationCity?.admin1 = state
            }
        
            if let cityTimezone = placemark.timeZone {
                self.currentLocationCity?.timezone = cityTimezone.identifier
            }
            print(placemark.country! + " | " + placemark.administrativeArea! + " | " + placemark.locality! + " | " + placemark.timeZone!.identifier)
        }
        print("ENDING FILL USER LOCATION !")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error of location : \(error.localizedDescription)")
    }
}
