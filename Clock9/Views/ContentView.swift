//
//  ContentView.swift
//  Clock9
//
//  Created by Jdrake on 1/18/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var userType = UserDefaults.standard.value(forKey: "loggedInUserType") as? String
    var body: some View {
        VStack{
            if status{
                if userType == "Admin" {
                    AdminView()
                } else {
                     EmployeeUIView()
                }

            }
            else{
                LoginScreen()
            }
        }.animation(.spring())
            .onAppear{
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main)
                {
                    (_) in
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    let userType = UserDefaults.standard.value(forKey: "loggedInUserType") as? String
                    self.status = status
                    self.userType = userType
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


