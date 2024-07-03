//
//  HiFiMenuView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/3.
//

import SwiftUI

struct HiFiMenuView: View {
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
        .navigationTitle("Transmitter")
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
    HiFiMenuView(dataModel: ManagementModel())
}
