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

struct LatLong {
    var latitude : CLLocationDegrees
    var longitude : CLLocationDegrees
}

struct TrackEmployeeView: View {
    let employee: Employee
    @ObservedObject var location = LocationManager()
    @ObservedObject var currentLocationManager = CurrentLocationManager()
//    @ObservedObject var employeeLocationManager = EmployeeLocationManager()
    var email = UserDefaults.standard.string(forKey: "loggedInUser")
    var userLatitude: String {
        return "\(currentLocationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(currentLocationManager.lastLocation?.coordinate.longitude ?? 0)"
    }

    
    
    var body: some View {
        
        NavigationView {
            VStack {
                MapView()
                    .frame(width: 425, height: 500, alignment: .top)
                    .navigationBarTitle(Text("Track Employee"),displayMode: .inline)
                    .edgesIgnoringSafeArea(.bottom)
                
                List {
                    Section{
                        ForEach(location.locations) { loca in
                            VStack(alignment: .leading) {
                                Text("Latitude: \(loca.latitude), Longitude: \(loca.longitude)")
                                Text("Time: \(loca.time)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    //                    .onDelete(perform: deleteEmployee)
                    //                    }
                }.frame(width: 425, height: 300, alignment: .bottom)
            }
            
            
            
        }
        .onAppear {
            self.location.fetchLocations()
            self.fetchEmployeeLastLocation(email: self.employee.email)
        }
    }
    
    func fetchEmployeeLastLocation(email: String) {
        
        let lat: CLLocationDegrees = 23.19023000 // Bhopal lat, long
        let long: CLLocationDegrees = 77.46790000 // Bhopal lat, long
        
        let date = Date()
        let currentFormatter = DateFormatter()
        currentFormatter.dateStyle = .medium
        let todaysDate = currentFormatter.string(from: date)
        
        let usersRef: DatabaseReference = Database.database().reference()
        
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        
        usersRef.child("employees").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild(newEmail){
                print("Employee Exist")
                for key in snapshot.key {
                    print("Key:\(key)")
                }
            } else {
                print("User does not exist")
            }
        })

    }
    
    
}


struct TrackEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        TrackEmployeeView(employee: testData[8])
    }
}
