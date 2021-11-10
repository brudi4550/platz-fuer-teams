//
//  MapView.swift
//  platz-fuer-teams
//
//  Created by Alexander Wolf on 09.11.21.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2D) {
            self.id = id
            self.coordinate = coordinate
    }
}

struct MapView: View {
    var place: Place
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [place]) { place in
            MapPin(coordinate: place.coordinate)
        }
        .onAppear() {
            setRegion(place.coordinate)
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: Place(coordinate: CLLocationCoordinate2D(latitude: 48.335926, longitude: 14.322861)))
    }
}
