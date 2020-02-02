//
//  LoginScreen.swift
//  Clock9
//
//  Created by Jdrake on 1/20/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginScreen: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: .init(colors: [Color("1"),Color("2")]), startPoint: .leading, endPoint: .trailing).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 22, content: {
                
                Image("clock9-logo").resizable().frame(width: 200, height: 200).padding(.bottom, 15)
                
                HStack{
                    
                    Image(systemName: "person.fill").resizable().frame(width: 20, height: 20).foregroundColor(.secondary)
                    TextField("Username", text: $user).padding(.leading, 12).font(.system(size: 20)).autocapitalization(.none)
                }
                .padding()
                .background(Color("3"))
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .shadow(radius: 10)
                
                HStack{
                    
                    Image(systemName: "lock.fill").resizable().frame(width: 15, height: 20).padding(.leading, 3).foregroundColor(.secondary)
                    SecureField("Password", text: $pass).padding(.leading, 12).font(.system(size: 20))
                    
                }
                .padding()
                .background(Color("3"))
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .shadow(radius: 10)
                
                
                Button(action: {
                    
                    //call httpLogin or sample login
                    
                    firebaseSignIn(email: self.user, password: self.pass){
                        (verified, status, type, employeeName, userId) in
                        if !verified{
                            self.msg = status
                            self.alert.toggle()
                        }
                        else{
                            print("Type:\(type)")
                            print("User:\(self.user)")
                            UserDefaults.standard.setValue(self.user, forKey: "loggedInUser")
                            UserDefaults.standard.setValue(type, forKey: "loggedInUserType")
                            UserDefaults.standard.setValue(employeeName, forKey: "employeeName")
                            UserDefaults.standard.setValue(userId, forKey: "userId")
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    
//                    emailSignIn(email: self.user, password: self.pass){
//                        (verified, status) in
//                        if !verified{
//                            self.msg = status
//                            self.alert.toggle()
//                        }
//                        else{
//
//                            UserDefaults.standard.set(true, forKey: "status")
//                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
//                        }
                    }
                }) {
                    
                    Text("Login").foregroundColor(.secondary).padding().frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                .background(Color("1"))
                .cornerRadius(50)
                .shadow(radius: 10)
            })
                .padding(.horizontal, 18)
                .alert(isPresented: $alert){
                    Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("OK")))
            }
        }
    }
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}


func emailSignIn(email: String, password: String, completion: @escaping (Bool, String) -> Void){
    Auth.auth().signIn(withEmail: email, password: password){
        (res, err) in
        if err != nil {
            completion(false,(err?.localizedDescription)!)
        }
        completion(true,(res?.user.email)!)
        //completion(true, "Success")
    }
}


func firebaseSignIn(email: String, password: String, completion: @escaping (Bool, String, String, String, String) -> Void){
    let usersRef: DatabaseReference = Database.database().reference()
    let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
    usersRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
        
            if snapshot.hasChild(newEmail){
                print("User Exists")
                // Get user value
                usersRef.child("users").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let userType = value?["userType"] as? String ?? ""
                    let employeeName = value?["employeeName"] as? String ?? ""
                    let userId = value?["userId"] as? String ?? ""
                    print(userType)
                    completion(true,email,userType,employeeName,userId)
                })
            } else {
                print("User does not exist")
    //            self.showingAlert = true
    //            self.createEmployee()
                completion(false,"User Does not exist","N/A","N/A","N/A")
            }
        })
}

func httpLogin(email: String, password: String, completion: @escaping (Bool, String) -> Void){
    
}
