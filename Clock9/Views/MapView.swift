//
//  MapView.swift
//  Clock9
//
//  Created by Jdrake on 24/01/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    var userLatitude: CLLocationDegrees
    var userLongitude: CLLocationDegrees
    var empName: String
    
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, employeeName: String) {
        self.userLatitude = latitude
        self.userLongitude = longitude
        self.empName = employeeName
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
        annotation.title = empName + " is here!"
        uiView.addAnnotation(annotation)
    }
}
