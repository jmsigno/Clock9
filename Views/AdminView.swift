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

    
    //    ref = Database.database().reference()
    var body: some View {
        
        TabView{
            
            NavigationView{
                List{
                    Section{
                        
                        NavigationLink(destination: AddEmployeeView()) {
                            Text("Add Employee")
                                .foregroundColor(.green)
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
            VStack{
                
                Text("Home")
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    
                }) {
                    
                    Text("Logout")
                }
            }
            .tabItem{
                VStack{
                    Image(systemName: "person.crop.circle.fill")
                    Text("Settings")
                }
            }
            .tag(2)
            
        }
        .onAppear {
            self.manage.fetchData()
        }
        
    }
  
    
    
    //create add employee interface
    func addEmployee(){
        
        manage.employees.append(Employee(name: "War Machine", email: "warmachine@clock9.com", password: "123456", phone: "1284321", userType: 2, imageUrl: ""))
        
    }
    
    
    func deleteEmployee(at offsets: IndexSet) {
        manage.employees.remove(atOffsets: offsets)
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(manage: EmployeeManager(employees: testData))
            .environment(\.colorScheme, .dark)
    }
}
