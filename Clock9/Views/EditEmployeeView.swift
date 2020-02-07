//
//  EditEmployeeView.swift
//  Clock9
//
//  Created by Jdrake on 07/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase

struct EditEmployeeView: View {
    
    let employee: Employee

    let defaultImageURL = "https://firebasestorage.googleapis.com/v0/b/clock9-f4f07.appspot.com/o/imagesFolder%2Ffile:%2FUsers%2Fankitkhanna%2FLibrary%2FDeveloper%2FCoreSimulator%2FDevices%2FCD06068A-9CFF-4871-A3E5-B618259192E8%2Fdata%2FContainers%2FData%2FApplication%2FD9B402BA-5204-44BF-AC9A-0E852F7CA5F0%2FDocuments%2F257F786A-79ED-4A55-96B4-54CC5662F020.png?alt=media&token=8567123f-0961-45df-84a2-c13db8179762"
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
                .init(red: 0.742, green: 0.242, blue: 0.242)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ScrollView(Axis.Set.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Create Employee").font(.title).padding().foregroundColor(.white).padding(.top, 20)
                    Text("Choose Image to Upload").padding().foregroundColor(.white)
                }
                // Choose Image to upload
                
                
                VStack {
                    
                    if (uiImage == nil) {
                        
                        Image(systemName: "camera.on.rectangle")
                            .accentColor(Color.purple)
                            .background(
                                Color.gray
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(6))
                            .onTapGesture {
                                self.showImagePicker = true
                        }
                    } else {
                        Image(uiImage: uiImage!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(6)
                            .onTapGesture {
                                self.showAction = true
                        }
                    }
                    
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
                    
                    TextField("Please enter your full name", text: $firstName)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        //                                                .background(Color.white)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                        .alert(isPresented:$showingAlert) {
                            Alert(title: Text("Update User"), message: Text("Employee details updated successfully."), dismissButton: .default(Text("OK")){
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
                    
                    TextField("Please enter your email address", text: $email)
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
                    
                    TextField("Please enter your Password", text: $password)
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
                    
                    TextField("Please enter your Phone Number", text: $phone)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        //                                                .background(Color.white)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                }
                
                
                
                
                
                Divider()
                // Save Employee
                Button(action: {
                    self.editEmployee(employee: self.employee, userType: 2)
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .leading)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Update")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding(Edge.Set.trailing, 55)
                    }
                }
                .frame(width: 300, height: 60, alignment: .center)
                .background(Color.green)
                .cornerRadius(CGFloat(20))
                .padding(.all)
                    
                
                
            }
        }.onAppear {
            self.firstName = self.employee.name
            self.email = self.employee.email
            self.phone = self.employee.phone
            self.password = self.employee.password
        }
    }
    
    // Edit Employee
    func editEmployee(employee: Employee, userType: Int) {
        
        let id = UUID()
        let upload = uploadFile()
        if let profileImage = uiImage {
            upload.uploadImage(id: id, name: firstName, email: email, password: password, phone: phone, type: userType, image: profileImage)
        } else {
            manage.editEmployee(id: id, name: firstName, email: email, password: password, phone: phone, type: userType, firebaseURL: defaultImageURL)
        }
        self.showingAlert = true
        
    }

    
    
}

struct EditEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EditEmployeeView(employee: Employee(id: UUID(), name: "", email: "", password: "", phone: "", userType: 2, imageUrl: ""))
    }
}
