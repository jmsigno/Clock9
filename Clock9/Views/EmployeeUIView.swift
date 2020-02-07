//
//  EmployeeUIView.swift
//  Clock9
//
//  Created by Jdrake on 01/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase
import CoreLocation

struct EmployeeUIView: View {
    @ObservedObject var manage = EmployeeManager()
    @ObservedObject var locationManager = EmployeeLocationManager()
    @ObservedObject var employeeAttendanceManager = EmployeeAttendanceManager()
    @State private var alertClockedIn = false
    @State private var alertClockedOut = false
    var email = UserDefaults.standard.string(forKey: "loggedInUser")
    var name = UserDefaults.standard.string(forKey: "employeeName")
    var userId = UserDefaults.standard.string(forKey: "userId")
    var userLatitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    var userLongitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var date: String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return (formatter.string(from: currentDateTime))
    }
    
    @State var clockInTime = "Not Clocked In"
    @State var clockOutTime = "Not Clocked Out"
    
    
    
    
    var body: some View {
        
        TabView{
            
            NavigationView{
                VStack {
                    //                    Clock In Label
                    HStack {
                        Text("Clock In: ")
                            .padding()
                        Text(clockInTime).foregroundColor(.green)
                        
                    }
                    //                    Clock Out Label
                    HStack {
                        Text("Clock Out: ")
                            .padding()
                        Text(clockOutTime).foregroundColor(.green)
                        
                    }
                    
                    // Update Location Button
                    Button(action: {
                        print("Update Location Button Tapped")
                        self.locationManager.updateLocation(email: self.email ?? "", id: self.userId ?? "", name: self.name ?? "", lat: self.userLatitude, long: self.userLongitude)
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .resizable()
                                .frame(width: 35, height: 35, alignment: .leading)
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("Update Current Location")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding(Edge.Set.trailing, 65)
                        }
                    }
                    .frame(width: 300, height: 60, alignment: .center)
                    .background(Color.init(red: 0.42, green: 0.2, blue: 0.42))
                    .cornerRadius(CGFloat(20))
                    .padding(.bottom)
                    
                    // Clock In Button
                    Button(action: {
                        print("Clock-In/ Out Button Tapped")
                        self.checkIfAlreadyClockIn(email: self.email!)
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .resizable()
                                .frame(width: 35, height: 35, alignment: .leading)
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("Clock-In / Clock-Out")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                                .padding(Edge.Set.trailing, 65)
                        }
                    }
                    .frame(width: 300, height: 60, alignment: .center)
                    .background(Color.init(red: 0.42, green: 0.2, blue: 0.42))
                    .cornerRadius(CGFloat(20))
                    .padding(.bottom)
                    .alert(isPresented:$alertClockedIn) {
                        Alert(title: Text("Clock In"), message: Text("You've already clocked in for the day."), primaryButton: .default(Text("Clock-Out"), action: {
                            self.employeeAttendanceManager.updateAttendance(email: self.email!, clockInOrClockOut: 2) // Set the clock out time
                            self.updateClockInOutTime(email: self.email!)
                        }), secondaryButton: .default(Text("Cancel")))
                    }
                    
                    
                }
                .navigationBarTitle(Text("Dashboard"), displayMode: .inline)
                    .listStyle(GroupedListStyle()) //grouping the sections
            }
            .tabItem{
                VStack{
                    Image(systemName: "person.3.fill")
                    Text("Dashboard")
                }
            }
            .tag(0)
            
            
            NavigationView{
                List{
                    
                        
                    ForEach(employeeAttendanceManager.employeeAttendance) { employee in
                            
                            
                            VStack(alignment: .leading) {
                                Text("Clock-In: \(employee.clockInTime); Clock-Out: \(employee.clockOutTime)")
                                    .foregroundColor(.green)
                                Text(employee.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            
                            
                        }
                        //                                        .onDelete(perform: deleteEmployee)
                    
                }
                .navigationBarTitle(Text("Attendance"), displayMode: .inline)
                    .listStyle(GroupedListStyle()) //grouping the sections
            }
            .transition(.slide)
            .tabItem{
                VStack{
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Attendance")
                }
            }
            .tag(1)
            Text("LogOut")
                .transition(.slide)
                .tabItem{
                    VStack{
                        Image(systemName: "person.crop.circle.fill")
                        Text("Settings")
                    }
            }
            .tag(2)
            
        }
        .onAppear {
            // Do something on Appear of view
            self.updateClockInOutTime(email: self.email!)
            self.employeeAttendanceManager.getAttendance(email: self.email!)
        }
        
    }
    
    // Below method checks if the user is already clock in.
    // if yes, then update the clock out value.
    // If no, then add a clock in value.
    
    func checkIfAlreadyClockIn(email: String) {
        
        let usersRef: DatabaseReference = Database.database().reference()
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        
        usersRef.child("attendance").observeSingleEvent(of: .value, with: { (snapshot) in
            print (newEmail)
            
            if snapshot.hasChild(newEmail){
                print("inside checkIfAlreadyClockIn")
                usersRef.child("attendance").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        let dict = child.value as? [String : AnyObject] ?? [:]
                        print (dict["clock_in_time"] ?? "No clock in value")
                        self.updateClockInOutTime(email: email)
                        self.alertClockedIn = true
                    }
                })
            } else {
                print("User does not exist")
                self.employeeAttendanceManager.updateAttendance(email: email, clockInOrClockOut: 1) // Set the clock in time
                self.updateClockInOutTime(email: email)
            }
        })
    }
    
    // Below method to fetch and update the Label with the latest clock in / clock out time
    func updateClockInOutTime (email: String) {
        let usersRef: DatabaseReference = Database.database().reference()
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        
        usersRef.child("attendance").observeSingleEvent(of: .value, with: { (snapshot) in
            print (newEmail)
            
            if snapshot.hasChild(newEmail){
//                print("inside checkIfAlreadyClockIn")
                usersRef.child("attendance").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        let dict = child.value as? [String : AnyObject] ?? [:]
                        let clockInTime = String(describing: dict["clock_in_time"]!)
                        let clockOutTime = String(describing: dict["clock_out_time"]!)
                        if clockInTime == "" {
                            self.clockInTime = "Not Clocked In"
                        } else {
                            self.clockInTime = clockInTime
                            UserDefaults.standard.setValue(clockInTime, forKey: "clockInTime")
                        }
                        if clockOutTime == "" {
                            self.clockOutTime = "Not Clocked Out"
                        } else {
                            self.clockOutTime = clockOutTime
                        }
                    }
                })
            } else {
                print("User does not exist")
            }
        })
        
    }
    
    
}

struct EmployeeUIView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeUIView()
    }
}
