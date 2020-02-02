//
//  EmployeeListView.swift
//  Clock9
//
//  Created by Jdrake on 1/18/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI // Library to load image from URL

struct EmployeeList: View {
    
    let employee: Employee
    
    var body: some View {
        NavigationLink(destination: EmployeeDetail(employee: employee)){
            //            Image(employee.imageName)
            /*
             .clipped()
             .scaledToFit()
             .cornerRadius(50) */
            WebImage(url: URL(string: employee.imageUrl)) // Library used to load image from URL
                .onSuccess { image, cacheType in
                    // Success
            }
            .resizable()
            .frame(width: 60, height: 60)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
            .shadow(radius: 5)
            
            
            VStack(alignment: .leading) {
                Text(employee.name)
                Text(employee.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
