//
//  Place.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/25/26.
//

import Foundation
import FoundationModels
import CoreLocation

@Generable
struct Place {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

extension Place.PartiallyGenerated {

    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else {
            return nil
        }

        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}
