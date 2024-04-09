//
//  ContentView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/8.
//

import SwiftUI


struct ContentView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    @ObservedObject private var dataModel = ManagementModel()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $dataModel.selectedMenuId) {
                Section {
                    ForEach(dataModel.manageItems, id: \.id) { item in
                        HStack {
                            Image(systemName: item.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text(item.name)
                                .font(.system(.title3, design: .rounded))
                                .bold()
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                } header: {
                    Text("Manage")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Section {
                    ForEach(dataModel.settingItems, id: \.id) { item in
                        HStack {
                            Image(systemName: item.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text(item.name)
                                .font(.system(.title3, design: .rounded))
                                .bold()
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                } header: {
                    Text("Setting")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationBarTitleDisplayMode(.automatic)
            .navigationTitle("Auracast™")
            
        } content: {
            if let selectedMenu = dataModel.getSelectedMenu() {
                switch selectedMenu.id {
                case dataModel.broacastGroup.id,
                    dataModel.transmitterConfig.id,
                    dataModel.receiverConfig.id:
                    List(dataModel.discoverdDevices, selection: $dataModel.selectedDevice) { device in
                        NavigationLink(value: device) {
                            HStack {
                                Image(systemName: device.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(device.name)
                            }
                            .padding(.init(top: 8, leading: 20, bottom: 8, trailing: 0))
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle(selectedMenu.name)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            if dataModel.isScanning {
                                ProgressView()
                            }
                        }
                    }
                    
                case dataModel.settings.id:
                    List(dataModel.settingsMenuItems) { item in
                        NavigationLink(value: item) {
                            HStack {
                                Image(systemName: item.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23, height: 23)
                                Text(item.name)
                            }
                            .padding(.init(top: 8, leading: 20, bottom: 8, trailing: 0))
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle(selectedMenu.name)
                    
                default:
                    Text("Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .navigationTitle(selectedMenu.name)
                }
            } else {
                Text("Please select a menu item")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
        } detail: {
            if let selectedMenuId = dataModel.selectedMenuId,
               dataModel.selectedDevice != nil {
                switch selectedMenuId {
                case dataModel.broacastGroup.id:
                    BroadcastGroupView(device: $dataModel.selectedDevice)
                
                case dataModel.transmitterConfig.id:
                    TransimitterView(device: $dataModel.selectedDevice)
                
                case dataModel.receiverConfig.id:
                    ReceiverView(device: $dataModel.selectedDevice)
                    
//                case dataModel.settings.id:

                default:
                    Text("Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("Please select an item")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        
    }
}

#Preview {
    ContentView()
}

