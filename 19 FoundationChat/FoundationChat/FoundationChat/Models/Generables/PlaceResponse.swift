//
//  PlaceResponse.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/26/26.
//

import Foundation
import FoundationModels

@Generable
struct PlacesResponse {
    let text: String
    let places: [Place]
}
