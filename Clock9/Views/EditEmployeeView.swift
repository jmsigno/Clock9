//
//  EditEmployeeView.swift
//  Clock9
//
//  Created by Jdrake on 07/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct EditEmployeeView: View {
    
    let employee: Employee
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
                .init(red: 255, green: 255, blue: 255)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ScrollView(Axis.Set.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Update Details").font(.title).padding().foregroundColor(.black).padding(20)
                }
                // Choose Image to upload
                
                
                VStack{
                    ZStack(alignment: .bottomTrailing){
                        if (uiImage == nil) {
                            WebImage(url: URL(string: employee.imageUrl))
                                .onSuccess {
                                    image, cacheType in
                            }
                            .resizable()
                            .frame(width: 100, height: 100).foregroundColor(.secondary)
                            .clipShape(Circle())
                            .onTapGesture {
                                self.showImagePicker = true
                            }
                        } else {
                            Image(uiImage: uiImage!)
                            .resizable()
                            .frame(width: 100, height: 100).foregroundColor(.secondary)
                            .clipShape(Circle())
                            .onTapGesture {
                                self.showAction = true
                            }
                        }
                        
                        Image(systemName: "camera.on.rectangle")
                        .resizable()
                        .frame(width: 20, height: 20).foregroundColor(.white)
                        .background(
                            Color.secondary
                                .frame(width: 30, height: 30)
                                .cornerRadius(6))
                    }
                    Text("Choose Image to Upload")
                        .foregroundColor(.secondary)
                }
                    .frame(width: 200, height: 50, alignment: .center)
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
                    .overlay(
                        Capsule()
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Full Name", text: $firstName)
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
                        .overlay(
                            Capsule()
                                .stroke(Color.secondary, lineWidth: 1)
                    )
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Email Address", text: $email)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                        .autocapitalization(UITextAutocapitalizationType.none)
                        .alert(isPresented:$checkUserAlert) {
                            Alert(title: Text("Check Email"), message: Text("Employee already exist with the email ID."), dismissButton: .default(Text("OK")))
                    }
                }
                
                // Password
                ZStack {
                    Capsule()
                    .fill(Color.white)
                    .overlay(
                        Capsule()
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Password", text: $password)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                }
                
                // Phone
                ZStack {
                    Capsule()
                    .fill(Color.white)
                    .overlay(
                        Capsule()
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                        .frame(width: CGFloat(370), height: CGFloat(50))
                        .padding()
                    
                    TextField("Phone Number", text: $phone)
                        .frame(width: CGFloat(300), height: CGFloat(50), alignment: .center)
                        .font(.body)
                        .foregroundColor(Color.init(red: 0.742, green: 0.242, blue: 0.242))
                        .padding()
                }
                
                Divider()
                // Save Employee
                Button(action: {
                    self.editEmployee(employee: self.employee, userType: self.employee.userType)
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
            manage.editEmployee(id: id, name: firstName, email: email, password: password, phone: phone, type: userType, firebaseURL: employee.imageUrl)
        }
        self.showingAlert = true
        
    }
    
    
    
}

struct EditEmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EditEmployeeView(employee: Employee(id: UUID(), name: "", email: "", password: "", phone: "", userType: 2, imageUrl: ""))
    }
}
