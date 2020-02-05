//
//  EmployeeLocationManager.swift
//  Clock9
//
//  Created by Ankit Khanna on 01/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import Firebase
import SwiftUI

class EmployeeLocationManager: NSObject, ObservableObject {
    
    //     var latitude : String
    //     var longitude : String
    //     var time: String

    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let locationManager = CLLocationManager()
    
    
    
    
    func updateLocation(email: String, id: String, name: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        let date = formatter.string(from: currentDateTime)
        // Firebase Database
        let userID = "\(id)"
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        let usersRef: DatabaseReference = Database.database().reference().child("employees")
        let employeeRef: DatabaseReference = usersRef.child(newEmail).child(date)
        
        
        // Formatting the data as per Firebase
        let employeeItem = [
            "userId": userID,
            "employeeName": name,
            "email": email,
            "lat": lat,
            "long": long,
            "date": date,
            ] as [String : Any]
        employeeRef.setValue(employeeItem)
        
        
    }
    
    
    
    
    
    
}

extension EmployeeLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        print(#function, location)
    }
    
}

