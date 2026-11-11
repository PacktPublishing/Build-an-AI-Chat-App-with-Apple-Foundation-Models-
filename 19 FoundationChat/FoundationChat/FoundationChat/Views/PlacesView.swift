//
//  PlaceView.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/26/26.
//

import SwiftUI
import MapKit
import FoundationModels

struct PlacesView: View {
    
    let places: [Place.PartiallyGenerated]
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 29.7604,
                longitude: -95.3698
            ),
            latitudinalMeters: 5_000,
            longitudinalMeters: 5_000
        )
    )
    
    var body: some View {
        Map(position: $position) {
            ForEach(places) { place in
                if let coordinate = place.coordinate {
                    Marker(place.name ?? "", coordinate: coordinate)
                }
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}



#Preview {
    PlacesView(places: [Place(name: "LA Fitness", address: "Houston, TX", latitude: 29.9664, longitude: -95.5482).asPartiallyGenerated()])
}
