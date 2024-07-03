//
//  PodsMenuView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/3.
//

import SwiftUI

struct PodsMenuView: View {
    @ObservedObject var dataModel: ManagementModel
    
    var body: some View {
        List(dataModel.discoverdDevices, selection: $dataModel.selectedDevice) { device in
            NavigationLink(value: device) {
                HStack {
                    Image(systemName: device.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text(device.name)
                        .font(.system(size: 15))
                }
                .padding(.init(top: 3, leading: 20, bottom: 3, trailing: 0))
            }
        }
        .listStyle(.plain)
        .navigationTitle("Pods")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if dataModel.isScanning {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    PodsMenuView(dataModel: ManagementModel())
}
