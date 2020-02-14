//
//  EmployeeAttendanceManager.swift
//  Clock9
//
//  Created by Jdrake on 01/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import Firebase


class EmployeeAttendanceManager: ObservableObject {
    
    init(attendance: [Attendance] = []) {
        self.employeeAttendance = attendance
    }
    
    // Method to get Attendance of a particular employee
    func getAttendance (email: String) {
        
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        let usersRef: DatabaseReference = Database.database().reference()
        usersRef.child("attendance").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(newEmail){
                print("Employee Exists: \(newEmail)")
                usersRef.child("attendance").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        let dict = child.value as? [String : AnyObject] ?? [:]
                        print (dict["clock_in_time"] ?? "No clock in value")
                        print (dict["clock_out_time"] ?? "No clock out value")
                        let clockInTime = dict["clock_in_time"]! as! String
                        let clockOutTime = dict["clock_out_time"]! as! String
                        self.employeeAttendance.append(Attendance(id: UUID(), email: newEmail, clockInTime: clockInTime, clockOutTime: clockOutTime))
                    }
                })
            } else {
                print("User does not exist")
            }
        })
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
        var employeeItem = [String:Any]()
        
        if clockInOrClockOut == 1 {
            clockInTime = date
        } else if clockInOrClockOut == 2 {
            clockInTime = UserDefaults.standard.string(forKey: "clockInTime") ?? "Not Clocked In"
            clockOutTime = date
        }
        
        // Formatting the data as per Firebase
        employeeItem = [
            "email" : email,
            "clock_in_time" : clockInTime,
            "clock_out_time" : clockOutTime,
            ] as [String : Any]
        employeeRef.setValue(employeeItem)
    }
    
    @Published var employeeAttendance = [Attendance]()
}
