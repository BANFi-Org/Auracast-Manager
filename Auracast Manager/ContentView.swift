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
                ForEach(dataModel.contentMenu) { cm in
                    Section {
                        ForEach(cm.menus, id: \.id) { item in
                            HStack {
                                Image(systemName: item.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text(item.name)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .padding(.init(top: 0, leading: 6, bottom: 4, trailing: 0))
                        }
                    } header: {
                        Text(cm.name)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
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
            if let selectedMenu = dataModel.selectedMenu {
                switch selectedMenu.type {
                case .pods:
                    PodsMenuView(dataModel: dataModel)
                    
                case .transmitter:
                    TransmitterMenuView(dataModel: dataModel)
                    
                case .about:
                    BanfiMenuView(dataModel: dataModel)
                    
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
            if let selectedMenu = dataModel.selectedMenu {
                switch selectedMenu.type {
                case .pods:
                    if dataModel.selectedDevice != nil {
                        PodsView(device: $dataModel.selectedDevice)
                    } else {
                        Text("Please select an item")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                case .transmitter:
                    if dataModel.selectedDevice != nil {
                        HiFiView(device: $dataModel.selectedDevice)
                    } else {
                        Text("Please select an item")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                case .preference:
                    Text("Preference Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                case .magicLab:
                    Text("Magic LAB Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                case .share:
                    Text("Share Constructing...")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                default:
                    if let selectedSubMenu = dataModel.selectedSubMenu {
                        switch selectedSubMenu.type {
                        case .aboutBanfi:
                            BanfiPartnersView()
                        case .premium:
                            BanfiFreePremiumServiceView()
                        default:
                            Text("Unknown Constructing...")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Please select an item")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
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

