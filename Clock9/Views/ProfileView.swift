//
//  ProfileView.swift
//  Clock9
//
//  Created by temp on 7/2/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import Firebase
import SwiftUI

struct ProfileView: View {
    
    //let employee: Employee
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Image(systemName: "person.fill")
                .resizable().frame(width: 100, height: 100).foregroundColor(.secondary)
                    .clipShape(Circle())
                VStack{
                    Text("Name")
                    Text("Email")
                    Text("Phone")
                }
            }.padding()
            
            
            List{
                Section{
                    Text("Profile ")
                    Text("Edit Profile")
                    Text("Reset Password")
                }

                Section{
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        
                    }) {
                        Text("Logout")
                    }
                }
                
            }.listStyle(GroupedListStyle())
        }
        
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
           ProfileView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
            
            ProfileView()
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")
            
            ProfileView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            .previewDisplayName("iPhone 11 Pro Max")
        }
        
    }
}

