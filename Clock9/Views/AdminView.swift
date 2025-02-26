//
//  AdminView.swift
//  Clock9
//
//  Created by Jdrake on 1/20/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct AdminView: View {
    @ObservedObject var manage = EmployeeManager()
    @State private var showAddEmployeeSheet = false
    let loggedInUser = UserDefaults.standard.string(forKey: "loggedInUser")
    
    var body: some View {
        TabView{
            NavigationView{
                List{
                    Section{
                        Button(action: {
                            self.showAddEmployeeSheet = true
                        }) {
                            Text("Add Employee")
                                .foregroundColor(.green)
                        }.sheet(isPresented: self.$showAddEmployeeSheet) {
                            AddEmployeeView()
                        }
                    }
                    
                    Section{
                        ForEach(manage.employees) { employee in
                            EmployeeList(employee: employee)
                        }
                        .onDelete(perform: deleteEmployee)
                    }
                }
                .navigationBarTitle(Text("Employees"), displayMode: .inline)
                    .listStyle(GroupedListStyle()) //grouping the sections
            }
            .tabItem{
                VStack{
                    Image(systemName: "person.3.fill")
                    Text("Employees")
                }
            }
            .tag(0)
            Text("Chat")
                .transition(.slide)
                .tabItem{
                    VStack{
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Messages")
                    }
            }
            .tag(1)
            ProfileView(email: self.loggedInUser!)
                .tabItem{
                    VStack{
                        Image(systemName: "person.crop.circle.fill")
                        Text("Profile")
                    }
            }
            .tag(2)
        }
        .onAppear {
            self.manage.fetchData()
        }
    }
    
    //Delete Employee
    func deleteEmployee(at offsets: IndexSet) {
        if let empObject = manage.employees[offsets.first!] as Employee? {
            manage.deleteEmployee(email: empObject.email)
        }
        manage.employees.remove(atOffsets: offsets)
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        
        AdminView(manage: EmployeeManager(employees: testData))
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Default")
        //
        //        Group{
        //            AdminView(manage: EmployeeManager(employees: testData))
        //            .environment(\.colorScheme, .dark)
        //            .previewDisplayName("Default")
        //
        //            AdminView(manage: EmployeeManager(employees: testData))
        //            .previewDevice(PreviewDevice(rawValue: "iPhone 10"))
        //            .previewDisplayName("iPhone 10")
        //            .environment(\.colorScheme, .dark)
        //
        //            AdminView(manage: EmployeeManager(employees: testData))
        //            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
        //            .previewDisplayName("XS Max")
        //            .environment(\.colorScheme, .dark)
        //
        //        }
        
    }
}
