//
//  BanfiFreePremiumServiceView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/2.
//

import SwiftUI

struct BanfiFreePremiumServiceView: View {
    @State private var selectedSegment = 0
    let segments = ["Free", "Premium", "Project Base"]
    
    var body: some View {
        VStack {
            Picker("Segments", selection: $selectedSegment) {
                ForEach(0..<3) { index in
                    Text(segments[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
            
            if selectedSegment == 0 {
                FreeServiceView()
            } else if selectedSegment == 1 {
                PremiumServiceView()
            } else {
                ProjectBaseServiceView()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BanfiFreePremiumServiceView()
}
