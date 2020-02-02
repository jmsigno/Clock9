//
//  MapView.swift
//  Clock9
//
//  Created by Ankit Khanna on 24/01/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    @ObservedObject var currentLocationManager = CurrentLocationManager()
    
    var userLatitude: CLLocationDegrees {
        return currentLocationManager.lastLocation?.coordinate.latitude ?? 0
    }

    var userLongitude: CLLocationDegrees {
        return currentLocationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    
        let location = CLLocationCoordinate2D(latitude: userLatitude,
            longitude: userLongitude)
    
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Employee"
//        annotation.subtitle = "London"
        uiView.addAnnotation(annotation)
    }
}
