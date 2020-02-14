//
//  LocationManager.swift
//  Clock9
//
//  Created by Jdrake on 25/01/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//


import SwiftUI
import Combine

class LocationManager : ObservableObject {
    init(locations: [Location] = []){
        self.locations = locations
    }
    @Published var locations = [Location]()
}
