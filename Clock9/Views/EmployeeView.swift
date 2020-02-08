//
//  EmployeeView.swift
//  Clock9
//
//  Created by Jdrake on 8/2/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase
import CoreLocation

struct EmployeeView: View {
    @State private var clockIn: Bool = false
    @State private var clockOut: Bool = false
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
                VStack{
                    HStack{
                        VStack(alignment: .leading, spacing: 10){
                            HStack {
                                Text("Clock In: ")
                                Text(clockInTime).foregroundColor(.blue)
                                
                            }
                            HStack {
                                Text("Clock Out: ")
                                Text(clockOutTime).foregroundColor(.blue)
                                
                            }
                        }.padding()
                        Spacer()
                    }.padding()
                    
                    
                    Spacer()
                    Image(systemName: "clock.fill")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .foregroundColor(clockOut ? .secondary : (clockIn ? .red : .green))
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation(.default) {
                                if !self.clockOut{
                                    self.isClockedIn(email: self.email!)
                                }
                            }
                    }
                    .alert(isPresented:$alertClockedIn) {
                        Alert(title: Text("Clock Out?"), message: Text("No more backsies once confirmed."), primaryButton: .default(Text("Clock-Out"), action: {
                            self.employeeAttendanceManager.updateAttendance(email: self.email!, clockInOrClockOut: 2) // Set the clock out time
                            self.updateClockInOutTime(email: self.email!)
                            self.clockOut.toggle()
                        }), secondaryButton: .default(Text("Cancel")))
                    }
                    
                    Text(clockOut ? "GOOD JOB!" : (clockIn ? "CLOCK OUT" : "CLOCK IN"))
                    Text(clockOut ? "You're done for today." : "")
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.blue)
                            .onTapGesture {
                                self.locationManager.updateLocation(email: self.email ?? "", id: self.userId ?? "", name: self.name ?? "", lat: self.userLatitude, long: self.userLongitude)
                        }
                        
                    }.padding()
                }
                .navigationBarTitle(Text("Dashboard"), displayMode: .inline)
            }
            .transition(.slide)
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
                            Text("Clock-In: \(employee.clockInTime)")
                                .foregroundColor(.green)
                            Text("Clock-Out: \(employee.clockOutTime)")
                                .foregroundColor(.red)
                            
                            Text(employee.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
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
            ProfileView(email: self.email!)
                .tabItem{
                    VStack{
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
            .tag(2)
            
        }
        .onAppear {
            self.updateClockInOutTime(email: self.email!)
            self.employeeAttendanceManager.getAttendance(email: self.email!)
        }
    }
    
    // Below method checks if the user is already clock in.
    // if yes, then update the clock out value.
    // If no, then add a clock in value.
    
    func isClockedIn(email: String) {
        
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
                self.employeeAttendanceManager.updateAttendance(email: email, clockInOrClockOut: 1) // Set the clock in time
                self.updateClockInOutTime(email: email)
                self.clockIn.toggle()
                
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

struct EmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeView()
    }
}
