//
//  AttendanceListUIView.swift
//  Clock9
//
//  Created by Jdrake on 06/02/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI

struct AttendanceListUIView: View {
    
    @ObservedObject var employeeAttendanceManager = EmployeeAttendanceManager()
    var email: String
    
    init(email: String) {
        self.email = email
    }
    
    var body: some View {
        List{
            
            ForEach(employeeAttendanceManager.employeeAttendance) { employee in
                
                VStack(alignment: .leading) {
                    Text("Clock-In: \(employee.clockInTime); Clock-Out: \(employee.clockOutTime)")
                        .foregroundColor(.green)
                    //Text(employee.email)
                      //  .font(.subheadline)
                        //.foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            print ("Email: \(self.email)")
            self.employeeAttendanceManager.getAttendance(email: self.email)
        }
        .navigationBarTitle(Text("Attendance"), displayMode: .inline)
            .listStyle(GroupedListStyle()) //grouping the sections
    }
    
}

struct AttendanceListUIView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceListUIView(email: "")
    }
}
