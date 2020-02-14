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
    @State var selectionAttendance: Int? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Library used to load image from URL
            WebImage(url: URL(string: employee.imageUrl))
                .onSuccess { image, cacheType in
            }
            .resizable()
            .aspectRatio(contentMode: zoomed ? .fill : .fit)
            .navigationBarTitle(Text(employee.name), displayMode: .inline)
            .onTapGesture {
                withAnimation(.default) {
                    self.zoomed.toggle()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            if !zoomed{
                VStack{
                    VStack(alignment: .leading, spacing: 5){
                        Text(employee.email)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                        Text(employee.phone)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                    .background(Color.white)
                    
                    Spacer()
                    
                    HStack{
                        NavigationLink(destination: TrackEmployeeView(employee: employee), tag: 1, selection: $selection) {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.green)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            //.cornerRadius(10)
                            .background(Color.white)
                        NavigationLink(destination: AttendanceListUIView(email: employee.email), tag: 2, selection: $selection) {
                            Image(systemName: "clock.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.green)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            //.cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                        NavigationLink(destination: Text("Chat View"), tag: 3, selection: $selection) {
                            Image(systemName: "message.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.green)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            //.cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                        NavigationLink(destination: EditEmployeeView(employee: employee), tag: 4, selection: $selection) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.green)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            //.cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            .background(Color.white)
                    }
                    .padding(10)
                }
            }
        }
    }
}

struct EmployeeDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeDetail(employee: testData[8])
    }
}
