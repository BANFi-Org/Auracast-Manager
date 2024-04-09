//
//  BroadcastGroupView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI

struct BroadcastGroupView: View {
    
    @Binding var device: Device!
    
    var body: some View {
        VStack {
            Image(systemName: device.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(device.name)
        }
        .padding()
    }
}


#Preview {
    @State var device: Device! = .init(id: UUID(),
                                       name: "BANFi Receiver",
                                       image: "airpodsmax")
    return BroadcastGroupView(device: $device)
}
