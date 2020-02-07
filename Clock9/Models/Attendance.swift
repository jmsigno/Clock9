//
//  Attendance.swift
//  Clock9
//
//  Created by Jdrake on 01/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct Attendance: Identifiable {
    var id = UUID()
    var email : String
    var clockInTime : String
    var clockOutTime : String
}
