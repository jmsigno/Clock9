//
//  Employee.swift
//  Clock9
//
//  Created by Jdrake on 1/18/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Combine

struct Employee : Identifiable{
    
    var id = UUID()
    var name: String
    var email: String
    var password: String
    var phone: String
    var userType: Int // 1 is Admin 2 is Employee
    var imageUrl: String
    var imageName: String{
        return name
        
    }
    var thumbnailName: String{
        return name + "Thumb"
    }
}




#if DEBUG

let testData = [
    Employee(name: "Ironman", email: "ironman@clock9.com", password: "123456", phone: "1234321", userType: 2, imageUrl: ""),
    Employee(name: "Black Widow", email: "blackwidow@clock9.com", password: "123456", phone: "1238321", userType: 2, imageUrl: ""),
    Employee(name: "Antman", email: "antman@clock9.com", password: "123456", phone: "1234521", userType: 2, imageUrl: ""),
    Employee(name: "Black Panther", email: "blackpanther@clock9.com", password: "123456", phone: "1224321", userType: 2, imageUrl: ""),
    Employee(name: "Hulk", email: "hulk@clock9.com", password: "123456", phone: "1231321", userType: 2, imageUrl: ""),
    Employee(name: "Captain Marvel", email: "cmarvel@clock9.com", password: "123456", phone: "1239321", userType: 2, imageUrl: ""),
    Employee(name: "Captain America", email: "camerica@clock9.com", password: "123456", phone: "1244321", userType: 2, imageUrl: ""),
    Employee(name: "Falcon", email: "falcon@clock9.com", password: "123456", phone: "1234321", userType: 2, imageUrl: ""),
    Employee(name: "Hawkeye", email: "hawkeye@clock9.com", password: "123456", phone: "1234321", userType: 2, imageUrl: ""),
    Employee(name: "Doctor Strange", email: "drstrange@clock9.com", password: "123456", phone: "1204321", userType: 2, imageUrl: ""),
    Employee(name: "Scarlet Witch", email: "scarletwitch@clock9.com", password: "123456", phone: "1234621", userType: 2, imageUrl: ""),
    Employee(name: "Spiderman", email: "spiderman@clock9.com", password: "123456", phone: "1234391", userType: 2, imageUrl: ""),
    Employee(name: "Thor", email: "thor@clock9.com", password: "123456", phone: "1234321", userType: 2, imageUrl: ""),
]

#endif


