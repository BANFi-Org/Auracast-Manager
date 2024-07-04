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
                                .font(.system(size: 17, weight: .regular))
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
                                .font(.system(size: 17, weight: .regular))
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
                case dataModel.receiverConfig.id:
                    PodsMenuView(dataModel: dataModel)
                    
                case dataModel.transmitterConfig.id:
                    HiFiMenuView(dataModel: dataModel)
                                        
                case dataModel.settings.id:
                    SettingMenuView(dataModel: dataModel)
                    
                default:
                    
                    Text("Unknown Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
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
                    let idx1 = dataModel.functionsMenuItems.firstIndex(where: {dataModel.selectedSettingId == $0.id})
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
                    let idx2 = dataModel.banfiMenuItems.firstIndex(where: {dataModel.selectedSettingId == $0.id})
                    if let idx = idx2 {
                        switch idx {
                        case 0:
                            BanfiPartnersView()
                            
                        case 1:
                            BanfiFreePremiumServiceView()
                            
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

