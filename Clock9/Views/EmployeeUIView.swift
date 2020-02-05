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
    
    var body: some View {
        
        TabView{
            
            NavigationView{
                VStack {
                    
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
                        print("Clock-In Button Tapped")
                        self.checkIfAlreadyClockIn(email: self.email!)
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .resizable()
                                .frame(width: 35, height: 35, alignment: .leading)
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("Clock-In")
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
                        Alert(title: Text("Clock In"), message: Text("You've already clocked in for the day."), dismissButton: .default(Text("OK")))
                    }
                    // Clock Out
                    Button(action: {
                        print("Clock-Out Button Tapped")
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .resizable()
                                .frame(width: 35, height: 35, alignment: .leading)
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("Clock-Out")
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
                    .alert(isPresented:$alertClockedOut) {
                        Alert(title: Text("Clock Out"), message: Text("You've already clocked out for the day."), dismissButton: .default(Text("OK")))
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
            Text("Chat")
                .transition(.slide)
                .tabItem{
                    VStack{
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Attendance")
                    }
            }
            .tag(1)
            VStack{
                Text("Profile")
                Button(action: {
                        
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        
                    }) {
                        
                        Text("Logout")
                    }
                }
            .tabItem{
                VStack{
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
            }
            .tag(2)
            
        }
        .onAppear {
            // Do something on Appear of view
        }
        
    }
    
    func checkIfAlreadyClockIn(email: String) {
        
        let usersRef: DatabaseReference = Database.database().reference()
        
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        
        usersRef.child("attendance").observeSingleEvent(of: .value, with: { (snapshot) in
            print (newEmail)
            if snapshot.hasChild(newEmail){
                print("inside checkIfAlreadyClockIn")
//                print(snapshot.value ?? "No value")
                snapshot.children.forEach { (child) in
                    print (child)
                }
            } else {
                print("User does not exist")
                self.employeeAttendanceManager.updateAttendance(email: email, clockInOrClockOut: 1)
            }
        })
    }
    
    
}

struct EmployeeUIView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeUIView()
    }
}
