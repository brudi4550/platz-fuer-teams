//
//  LearningSpace.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import Foundation
import SwiftUI
import CoreLocation

struct LearningSpace: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var occupied: Bool
    var building: String
    var nrOfSeats: Int
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
