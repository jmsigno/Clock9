//
//  EmployeeDetail.swift
//  Clock9
//
//  Created by Jdrake on 1/19/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmployeeDetail: View {
    let employee: Employee
    @State private var zoomed: Bool = false
    @State var selection: Int? = nil
    
    var body: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 0) {
                
                ZStack(alignment: .topLeading) {
//                    Image(employee.imageName)
                    WebImage(url: URL(string: employee.imageUrl)) // Library used to load image from URL
                        .onSuccess { image, cacheType in
                            // Success
                    }
                        .resizable()
                        .aspectRatio(contentMode: zoomed ? .fill : .fit)
                        .navigationBarTitle(Text(employee.name), displayMode: .inline)
                        .onTapGesture {
                            withAnimation(.default) {
                                //  self.zoomed.toggle()
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text("Name: \(employee.name)")
                        Text("Email: \(employee.email)")
                        Text("Phone: \(employee.phone)")
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.7))
                }
                
            }
            // Track Employee Button
            NavigationLink(destination: TrackEmployeeView(employee: employee), tag: 1, selection: $selection) {
                EmptyView()
            }
                Button(action: {
                    print("Track Employee Button Tapped")
                    self.selection = 1
                }) {
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .leading)
                            .foregroundColor(.white)
                            .padding()
                        
                        Text("Track Employee")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .padding(Edge.Set.trailing, 60)
                    }
                }
                .frame(width: 300, height: CGFloat(60), alignment: .center)
                .background(Color.init(red: 0.42, green: 0.2, blue: 0.42))
                .cornerRadius(20)
                .padding(.all)
            
            
            // Edit Employee Button
            Button(action: {
                print("Edit Employee Button Tapped")
            }) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .leading)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Edit Employee")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding(Edge.Set.trailing, 70)
                }
                
            }
            .frame(width: 300, height: CGFloat(60), alignment: .center)
            .background(Color.init(red: 0.42, green: 0.2, blue: 0.42))
            .cornerRadius(CGFloat(20))
            .padding(.bottom)
            
            //             View Attendance
            Button(action: {
                print("View Attendance Button Tapped")
            }) {
                HStack {
                    Image(systemName: "clock.fill")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .leading)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("View Attendance")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding(Edge.Set.trailing, 50)
                }
            }
            .frame(width: 300, height: 60, alignment: .center)
            .background(Color.init(red: 0.42, green: 0.2, blue: 0.42))
            .cornerRadius(CGFloat(20))
            .padding(.bottom)
            
            
            // Send Attendance
            Button(action: {
                print("Send Message Button Tapped")
            }) {
                HStack {
                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .leading)
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Send Message")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .padding(Edge.Set.trailing, 65)
                }
            }
            .frame(width: 300, height: 60, alignment: .center)
            .background(Color.init(red: 0.42, green: 0.2, blue: 0.42))
            .cornerRadius(CGFloat(20))
            .padding(.bottom)
        }
        
        // Old Code
        //    ZStack(alignment: .bottomLeading){
        //            Image(employee.imageName)
        //                .resizable()
        //                .aspectRatio(contentMode: zoomed ? .fill : .fit)
        //                .navigationBarTitle(Text(employee.name), displayMode: .inline)
        //                .onTapGesture {
        //                    withAnimation(.default) {
        //                        self.zoomed.toggle()
        //                    }
        //                }
        //
        //                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        //
        //
        //            if !zoomed {
        //                VStack(alignment: .leading, spacing: 5){
        //                    Text("Name: \(employee.name)")
        //                    Text("Email: \(employee.email)")
        //                    Text("Phone: \(employee.phone)")
        //                }
        //                .padding(20)
        //                .background(Color.white.opacity(0.7))
        //                .transition(.move(edge: .bottom))
        //
        //
        //            }
        //        }
    }
}

struct EmployeeDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetail(employee: testData[8])
    }
}
