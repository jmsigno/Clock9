//
//  EmployeeManager.swift
//  Clock9
//
//  Created by Jdrake on 1/19/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Firebase


class EmployeeManager : ObservableObject {
    //var employees: [Employee]{
    //   didSet{ didChange.send()}
    // }
    
    init(employees: [Employee] = []){
        self.employees = employees
    }
    
    func createEmployee(id: UUID, name: String, email: String, password: String, phone: String, type: Int, firebaseURL: String) {
        // Firebase Database
        let userID = "\(id)"
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        let usersRef: DatabaseReference = Database.database().reference().child("users")
        let employeeRef: DatabaseReference = usersRef.child(newEmail)
        var userType: String { // User Type 1 is Admin 2 is Employee
            if type == 1 {
                return "Admin"
            } else if type == 2 {
                return "Employee"
            }
            return "Invalid Employee"
        }
        // Formatting the data as per Firebase
        let employeeItem = [
            "userId": userID,
            "employeeName": name,
            "email": email,
            "password": password,
            "phone": phone,
            "userType": userType, // User Type 1 is Admin 2 is Employee
            "imageURL": firebaseURL
        ]
        employeeRef.setValue(employeeItem)
        
        
    }
    
    func editEmployee(id: UUID, name: String, email: String, password: String, phone: String, type: Int, firebaseURL: String) {
          // Firebase Database
          let userID = "\(id)"
          let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
          let usersRef: DatabaseReference = Database.database().reference().child("users")
          let employeeRef: DatabaseReference = usersRef.child(newEmail)
          var userType: String { // User Type 1 is Admin 2 is Employee
              if type == 1 {
                  return "Admin"
              } else if type == 2 {
                  return "Employee"
              }
              return "Invalid Employee"
          }
          // Formatting the data as per Firebase
          let employeeItem = [
              "userId": userID,
              "employeeName": name,
              "email": email,
              "password": password,
              "phone": phone,
              "userType": userType, // User Type 1 is Admin 2 is Employee
              "imageURL": firebaseURL
          ]
          employeeRef.setValue(employeeItem)
          
          
      }
    
    func deleteEmployee(email: String) {
        
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        let usersRef: DatabaseReference = Database.database().reference().child("users")
        let employeeRef: DatabaseReference = usersRef.child(newEmail)
        
        employeeRef.removeValue { error, _ in
            print(error ?? "Employee Deleted.")
        }
        
    }
    
    
    // Firebase Database
    lazy var usersRef: DatabaseReference = Database.database().reference().child("users")
    var newEmployeeRefHandle: DatabaseHandle?
    
    func fetchData () {
        let messageQuery = usersRef.queryLimited(toLast:100)
        newEmployeeRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let resultData = snapshot.value as! Dictionary<String, String>
//            print(resultData)
            if let userId = resultData["userId"] as String?, let password = resultData["password"] as String?, let email = resultData["email"] as String?, let employeeName = resultData["employeeName"] as String?, let phone = resultData["phone"] as String?, let userType = resultData["userType"] as String?, let imageURLs = resultData["imageURL"] as String?, userId.count > 0 {
                if (userType == "Employee") {
                    // Append Firebase DB Results to the Employee Struct
                    self.employees.append(Employee(name: employeeName, email: email, password: password, phone: phone, userType: Int(userType) ?? 2, imageUrl: imageURLs))
                }
            }
        })
    }
    //let didChange = PassthroughSubject<Void, Never>()
    @Published var employees = [Employee]()
}

