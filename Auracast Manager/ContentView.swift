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
    
    @Environment(\.dismiss) var dismiss
    
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
            .navigationTitle("BANFi")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Image("auracast")
                        .resizable()
                        .scaledToFit()
                }
            }
            
        } content: {
            if let selectedMenu = dataModel.getSelectedMenu() {
                switch selectedMenu.id {
                case dataModel.transmitterConfig.id,
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
                    List(selection: $dataModel.selectedSettingMenuId) {
                        Section {
                            ForEach(dataModel.functionsMenuItems, id: \.id) { item in
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
                        } header: {
                            Text("Function")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Section {
                            ForEach(dataModel.banfiMenuItems, id: \.id) { item in
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
                        } header: {
                            Text("About")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
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
            if let selectedMenuId = dataModel.selectedMenuId {
                switch selectedMenuId {
                case dataModel.transmitterConfig.id:
                    if dataModel.selectedDevice != nil {
                        HiFiView(device: $dataModel.selectedDevice)
                    } else {
                        Text("Please select an item")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                case dataModel.receiverConfig.id:
                    if dataModel.selectedDevice != nil {
                        PodsView(device: $dataModel.selectedDevice)
                    } else {
                        Text("Please select an item")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                case dataModel.settings.id:
                    var idx1 = dataModel.functionsMenuItems.firstIndex(where: {dataModel.selectedSettingMenuId == $0.id})
                    if let idx = idx1 {
                        switch idx {
                        case 0:
                            Text("Preference Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        case 1:
                            Text("Magic Lab Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        case 2:
                            Text("Share Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        case 3:
                            Text("About Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        default:
                            Text("Unknown Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    var idx2 = dataModel.banfiMenuItems.firstIndex(where: {dataModel.selectedSettingMenuId == $0.id})
                    if let idx = idx2 {
                        switch idx {
                        case 0:
                            Text("Partner Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        case 1:
                            Text("Service Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        default:
                            Text("Unknown Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                default:
                    Text("Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}

