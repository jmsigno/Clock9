//
//  Location.swift
//  Clock9
//
//  Created by Jdrake on 25/01/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Combine

struct Location: Identifiable {
    var id = UUID()
    var latitude : String
    var longitude : String
    var time: String
    var name : String
    var userId : String
    var email : String
    

}

struct currentLocation: Identifiable {
    var id = UUID()
    var latitude : String
    var longitude : String
    var time: String
    var name : String
    var userId : String
}
