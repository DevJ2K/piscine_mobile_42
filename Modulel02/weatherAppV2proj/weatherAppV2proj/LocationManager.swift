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
