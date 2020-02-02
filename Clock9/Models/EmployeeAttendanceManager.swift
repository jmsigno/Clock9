//
//  EmployeeAttendanceManager.swift
//  Clock9
//
//  Created by Ankit Khanna on 01/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import Firebase


class EmployeeAttendanceManager: ObservableObject {
    
    init(attendance: [Attendance] = []) {
        self.employeeAttendance = attendance
    }
    
    
    
    // If clockInOrClockOut is 1 clock in, 2 is clock out
    func updateAttendance(email: String, clockInOrClockOut: Int) {
        
        let currentDateTime = Date()
        let formatterHeader = DateFormatter()
        formatterHeader.dateStyle = .medium
        let dateHeader = formatterHeader.string(from: currentDateTime)
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        let date = formatter.string(from: currentDateTime)
        // Firebase Database
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        let usersRef: DatabaseReference = Database.database().reference().child("attendance")
        let employeeRef: DatabaseReference = usersRef.child(newEmail).child(dateHeader)
        var clockInTime = ""
        var clockOutTime = ""
        if clockInOrClockOut == 1 {
            clockInTime = date
        } else if clockInOrClockOut == 2 {
            clockOutTime = date
        }
        
        // Formatting the data as per Firebase
        let employeeItem = [
            "email" : email,
            "clock_in_time" : clockInTime,
            "clock_out_time" : clockOutTime,
            ] as [String : Any]
        employeeRef.setValue(employeeItem)
        
        
        
    }
    
    
    @Published var employeeAttendance = [Attendance]()
}
