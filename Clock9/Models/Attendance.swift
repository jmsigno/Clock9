//
//  Attendance.swift
//  Clock9
//
//  Created by Ankit Khanna on 01/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation


struct Attendance: Identifiable {
    var id = UUID()
    var email : String
    var clockInTime : String
    var clockOutTime : String
}
