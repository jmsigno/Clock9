//
//  AddEmployeeView.swift
//  Clock9
//
//  Created by Jdrake on 1/20/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase

struct AddEmployeeView: View {
    
    let defaultImageURL = "https://firebasestorage.googleapis.com/v0/b/clock9-f4f07.appspot.com/o/imagesFolder%2Ffile:%2FUsers%2Ftemp%2FLibrary%2FDeveloper%2FCoreSimulator%2FDevices%2F4DB83F47-A5B8-4EDD-AA6E-32E427A96B22%2Fdata%2FContainers%2FData%2FApplication%2FB0C6B407-D45F-4FCE-9E6A-65F6D8029617%2FDocuments%2F130456DC-347B-43C9-8E6B-D2BB771FD72F.png?alt=media&token=4b7f702e-b976-464d-a106-75c9a1071124"
    @State private var firstName: String =  ""
    @State private var email: String =  ""
    @State private var password: String =  ""
    @State private var phone: String =  ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @State private var showingAlert = false
    @State private var checkUserAlert = false
    @State var createEmployeeButtonTapped = false
    @ObservedObject var manage = EmployeeManager()
    
    // Image Picker
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var uiImage: UIImage? = nil
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Action"),
            message: Text("Quotemark"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.uiImage = nil
                })
        ])
        
    }
    
    var body: some View {
        
        ZStack {
            Color
                .init(red: 0, green: 0, blue: 0)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ScrollView(Axis.Set.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Create Employee").font(.title).padding().foregroundColor(.white).padding(20)
                }.padding()
                
                VStack(spacing: 20) {
                    ZStack(alignment: .bottomTrailing){
                        if (uiImage == nil) {
                            Image(systemName: "camera.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.secondary)
                                .clipShape(Circle())
                                .onTapGesture {
                                    self.showImagePicker = true
                            }
                        } else {
                            Image(uiImage: uiImage!)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .onTapGesture {
                                    self.showAction = true
                            }
                            Image(systemName: "camera.on.rectangle")
                            .resizable()
                            .frame(width: 20, height: 20).foregroundColor(.white)
                            .background(
                                Color.secondary
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(6))
                        }
                    }
                    
                    Text("Choose Image to Upload")
                    .foregroundColor(.white)
                    
                } .frame(width: 200, height: 50, alignment: .center)
                    
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        self.showImagePicker = false
                    }, content: {
                        ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
                    })
                    
                    .actionSheet(isPresented: $showAction) {
                        sheet
                }
                
                // Full Name
                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Name", text: $firstName)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        //                                                .background(Color.white)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                        .alert(isPresented:$showingAlert) {
                            Alert(title: Text("Create Employee"), message: Text("Employee created successfully."), dismissButton: .default(Text("OK")){
                                self.presentationMode.wrappedValue.dismiss()
                                })
                    }
                }.padding(.top, 50)
                
                // Email Address
                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Email", text: $email)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        //                                                .background(Color.white)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .padding()
                        .alert(isPresented:$checkUserAlert) {
                            Alert(title: Text("Check Email"), message: Text("Employee already exist with the email ID."), dismissButton: .default(Text("OK")))
                    }
                }
                
                // Password
                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Password", text: $password)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        //                                                .background(Color.white)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                }
                
                // Phone
                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Phone", text: $phone)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        //                                                .background(Color.white)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                }

                Divider()
                // Save Employee
                Button(action: {
                    self.checkIfEmployeeExists(email: self.email)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .leading)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Create Employee")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding(Edge.Set.trailing, 55)
                    }
                }
                .frame(width: 300, height: 60, alignment: .center)
                .background(Color.blue)
                .cornerRadius(CGFloat(20))
                .padding(.all)
                    
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
                
            }
        }
    }
    
    // Check if Employee Exists in the Firebase Database
    func checkIfEmployeeExists(email: String) {
        
        let usersRef: DatabaseReference = Database.database().reference()
        
        let newEmail = email.replacingOccurrences(of: ".", with: ",") // Firebase doesn't allow . so replaced it with ,
        
        usersRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            print(email)
            if snapshot.hasChild(newEmail){
                print("User Exists")
                self.checkUserAlert = true
                
            } else {
                print("User does not exist")
                self.showingAlert = true
                self.createEmployee()
            }
        })
        
    }

    // Create Employee Function
    func createEmployee() {
        let id = UUID() // This is to give a unique ID for every user. We are passing it to Firebase DB.
        
        let employeeType = 2 // User Type 1 is Admin 2 is Employee
        //  First pass the employee data to the upload Image function and when the image gets uploaded successfully then upload the image URL and other data to the Firebase Realtime Database on the completion handler of the upload Image code.
        let upload = uploadFile()
        if let profileImage = uiImage {
            upload.uploadImage(id: id, name: firstName, email: email, password: password, phone: phone, type: employeeType, image: profileImage)
        } else {
            manage.createEmployee(id: id, name: firstName, email: email, password: password, phone: phone, type: employeeType, firebaseURL: defaultImageURL)
        }
        self.showingAlert = true
        
        print("Employee Created Successfully.")
        
    }
    
}

struct AddEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmployeeView()
    }
}
