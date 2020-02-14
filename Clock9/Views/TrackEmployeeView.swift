//
//  TrackEmployeeView.swift
//  Clock9
//
//  Created by Jdrake on 1/20/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation
import Firebase

struct TrackEmployeeView: View {
    let employee: Employee
    @ObservedObject var location = LocationManager()
    @ObservedObject var currentLocationManager = CurrentLocationManager()
    @ObservedObject var employeeLocationManager = EmployeeLocationManager()
    var email = UserDefaults.standard.string(forKey: "loggedInUser")
    @State var currentLat: CLLocationDegrees = -37.818212 // Default Lat
    @State var currentLong: CLLocationDegrees = 144.9521133 // Default Long
    
    var body: some View {
        VStack {
            MapView(latitude: currentLat, longitude: currentLong, employeeName: employee.name)
                .navigationBarTitle(Text("\(employee.name)'s Locations"),displayMode: .inline)
                .edgesIgnoringSafeArea(.bottom)
            List {
                Section{
                    ForEach(location.locations) { loca in
                        VStack(alignment: .leading) {
                            Button(action: {
                                self.currentLat = CLLocationDegrees(loca.latitude)!
                                self.currentLong = CLLocationDegrees(loca.longitude)!
                            }) {
                                Text("Location on \(loca.time)")
                                .foregroundColor(.green)
                                Text("Latitude: \(loca.latitude), Longitude: \(loca.longitude)")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.fetchEmployeeLastLocation(email: self.employee.email)
        }
    }
    
    mutating func assignLocationValue (lat: CLLocationDegrees, long: CLLocationDegrees) {
        self.currentLat = lat
        self.currentLong = long
    }
    
    func fetchEmployeeLastLocation(email: String) {
        let usersRef: DatabaseReference = Database.database().reference()
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        usersRef.child("employees").child(newEmail).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = child.value as? [String : AnyObject] ?? [:]
                let id = UUID()
                print(dict["lat"] ?? "No Latitude")
                print(dict["long"] ?? "No Longitude")
                let latitude = "\(String(describing: dict["lat"]!))"
                let longitude = "\(String(describing: dict["long"]!))"
                let date = "\(String(describing: dict["date"]!))"
                let name = "\(String(describing: dict["employeeName"]!))"
                let userId = "\(String(describing: dict["userId"]!))"
                let email = "\(String(describing: dict["email"]!))"
                let loca = Location(id: id, latitude: latitude, longitude: longitude, time: date, name: name, userId: userId, email: email)
                self.location.locations.append(loca)
            }
        })
    }
}

struct TrackEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        TrackEmployeeView(employee: testData[8])
    }
}
