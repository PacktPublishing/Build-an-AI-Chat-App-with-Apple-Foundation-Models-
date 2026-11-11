//
//  PlaceTool.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/25/26.
//

import Foundation
import FoundationModels
import CoreLocation
import MapKit

struct PlaceTool: Tool {
    
    let locationManager: LocationManager
    
    let name = "searchNearbyPlaces"
    let description = """
    Searches for places near the user's current location, such as restaurants, cafes, gyms, stores, and other points of interest.
    Use this tool when the user asks to find nearby places or local businesses.
    """
    
    @Generable
    struct Arguments {
        @Guide(description: "The type of place or search term, such as sushi, pizza, coffee, gym, or pharmacy.")
        let query: String
    }
    
    func call(arguments: Arguments) async throws -> [Place] {
        
        let location = try await locationManager.requestLocation()
        let userCoordinate = location.coordinate
        
        let searchQuery = arguments.query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        request.region = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 3_200, longitudinalMeters: 3_200)
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        if response.mapItems.isEmpty {
            return []
        }
        
        let results = response.mapItems.prefix(5).compactMap { item -> Place? in
            guard let name = item.name else { return nil }
            let address = formattedAddress(for: item)
            guard let itemCoordinate = coordinate(for: item) else { return nil }
            let place = Place(name: name, address: address, latitude: itemCoordinate.latitude, longitude: itemCoordinate.longitude)
            return place
        }
        
        return results
    }
    
    private func formattedAddress(for item: MKMapItem) -> String {
        if #available(iOS 26.0, *) {
            return item.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true)
                ?? item.address?.fullAddress
                ?? "Address unavailable"
        } else {
            return item.placemark.title ?? "Address unavailable"
        }
    }
    
    private func coordinate(for item: MKMapItem) -> CLLocationCoordinate2D? {
        if #available(iOS 26.0, *) {
            return item.location.coordinate
        } else {
            return item.placemark.coordinate
        }
    }
    
}
