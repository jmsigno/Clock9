//
//  LocationManager.swift
//  Clock9
//
//  Created by Ankit Khanna on 25/01/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class LocationManager : ObservableObject {

    init(locations: [Location] = []){
        self.locations = locations
    }
    
    
    func fetchLocations() {
        let id = UUID()
        self.locations.append(Location(id: id, latitude: "23.190230", longitude: "77.467900", time: "25 January 2020, 12:32PM", name: "Ankit Khanna", userId: "123456789", email: "Ankit.khanna@gmail.com"))
        self.locations.append(Location(id: id, latitude: "23.190230", longitude: "77.467700", time: "25 January 2020, 09:32AM", name: "Ankit Khanna", userId: "123456789", email: "Ankit.khanna@gmail.com"))
    }
    
    @Published var locations = [Location]()

}

