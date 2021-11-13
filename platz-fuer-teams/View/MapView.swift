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
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.none), annotationItems: [place], annotationContent: { location in
            MapPin(coordinate: place.coordinate, tint: .red)
        })
        .onAppear() {
            viewModel.checkIfLocationServicesIsEnabled()
            setRegion(place.coordinate)
        }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            )
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            checkLocationAuthorization()
            locationManager!.delegate = self
        } else {
            print("Ortungsdienste deaktiviert.")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Ortungsdienste deaktiviert.")
        case .denied:
            print("Ortungsdienste können in den Einstellungen aktiviert werden.")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkIfLocationServicesIsEnabled()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: Place(coordinate: CLLocationCoordinate2D(latitude: 48.335926, longitude: 14.322861)))
    }
}
