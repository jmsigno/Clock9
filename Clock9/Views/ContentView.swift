//
//  ContentView.swift
//  Clock9
//
//  Created by Jdrake on 1/18/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var userType = UserDefaults.standard.value(forKey: "loggedInUserType") as? String
    @State private var isUnlocked = false
    
    
    var body: some View {
        VStack{
            //if self.isUnlocked {
                if status {
                    if userType == "Admin" {
                        AdminView()
                    } else {
                        //EmployeeUIView()
                        EmployeeView()
                    }
                } else {
                    LoginScreen()
                }
                
            //} else {
            //    LoginScreen()
            //}
            
            
        }.animation(.spring())
            .onAppear{
                self.authenticate()
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
    
    // For testing with simulator Go to Hardware > FaceID > Matching Face
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Please use FaceID for login."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


