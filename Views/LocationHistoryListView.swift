//
//  EmployeeListView.swift
//  Clock9
//
//  Created by Jdrake on 1/18/20.
//  Copyright © 2020 jmsigno. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI // Library to load image from URL

struct LocationHistoryListView: View {
    
    let location: Location
    
    var body: some View {
    
            VStack(alignment: .leading) {
                Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
                Text("Time: \(location.time)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        
    }
}
