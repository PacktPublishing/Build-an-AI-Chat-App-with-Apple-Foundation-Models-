//
//  LocationManager.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/25/26.
//

import Foundation
import Observation
import CoreLocation

enum LocationError: LocalizedError, Equatable {
    case permissionDenied
    case restricted
    case unableToFindLocation
    case coreLocation(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied. Please enable it in Settings."
        case .restricted:
            return "Location access is restricted."
        case .unableToFindLocation:
            return "Unable to determine your location right now."
        case .coreLocation(let message):
            return message
        }
    }
}

@Observable
class LocationManager: NSObject {
    
    private let manager: CLLocationManager
    var currentLocation: CLLocation?
    var error: LocationError?
    
    override init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        super.init()
        
        manager.delegate = self
    }
    
    func requestLocation() async throws -> CLLocation {
        
        for try await update in CLLocationUpdate.liveUpdates() {
            if let location = update.location {
                return location
            }
        }
        
        throw LocationError.unableToFindLocation
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.error = .coreLocation(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            // Parental controls or system restriction
            error = .restricted
            
        case .denied:
            // User explicitly denied
            error = .permissionDenied
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted → get location
            manager.requestLocation()
            
        @unknown default:
            error = .coreLocation("Unknown authorization state.")
        }
    }
}

