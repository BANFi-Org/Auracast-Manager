//
//  ManagementModel.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI


class ManagementModel: ObservableObject {
    
    @Published var discoverdDevices: [Device]
    
    @Published var selectedMenuId: MenuItem.ID? {
        didSet {
            guard selectedMenuId != oldValue else {
                return
            }
            
            selectedDevice = nil
            
            DeviceProvider.shared.stop()
            
            discoverdDevices.removeAll()
            
            if let id = selectedMenuId {
                for section in contentMenu {
                    for menu in section.menus {
                        if menu.id == id {
                            selectedMenu = menu
                        }
                    }
                }
            } else {
                selectedMenu = nil
            }
            
            if let selectedMenu = selectedMenu {
                switch selectedMenu.type {
                case .pods, .transmitter: DeviceProvider.shared.start()
                default: break
                }
            }
        }
    }
    
    @Published var selectedMenu: MenuItem?
    
    @Published var selectedDevice: Device?
    
    @Published var selectedSubMenuId: MenuItem.ID? {
        didSet {
            guard selectedSubMenuId != oldValue else {
                return
            }
            if let id = selectedSubMenuId {
                for menu in aboutMenuItems {
                    if menu.id == id {
                        selectedSubMenu = menu
                    }
                }
            } else {
                selectedSubMenu = nil
            }
        }
    }
    
    @Published var selectedSubMenu: MenuItem?
    
    var manageMenuItems: [MenuItem]
    
    var functionsMenuItems: [MenuItem]
    
    var aboutMenuItems: [MenuItem]
    
    var aboutSubMenuItems: [MenuItem]
    
    var contentMenu: [MainMenuItem]
    
    var isScanning: Bool {
        return DeviceProvider.shared.isRunning
    }
    
    init() {
        manageMenuItems = [MenuItem(type: .pods, name: "Pods", image: "airpodsmax"),
                           MenuItem(type: .transmitter, name: "Transimtter", image: "hifireceiver")]
        
        functionsMenuItems = [MenuItem(type: .preference, name: "Preference", image: "checklist"),
                              MenuItem(type: .magicLab, name: "Magic Lab", image: "lasso.badge.sparkles"),
                              MenuItem(type: .share, name: "Share", image: "square.and.arrow.up")]
        
        aboutMenuItems = [MenuItem(type: .aboutBanfi, name: "BANFi Semiconductor", image: "exclamationmark.circle"),
                          MenuItem(type: .premium, name: "Free & Premium Services", image: "dollarsign.circle")]
        
        aboutSubMenuItems = [MenuItem(type: .about, name: "BANFi", image: "rectangle.stack")]
        
        contentMenu = [MainMenuItem(type: .manage, name: "Manage", menus: manageMenuItems),
                       MainMenuItem(type: .about, name: "About", menus: aboutSubMenuItems),
                       MainMenuItem(type: .funtion, name: "Function", menus: functionsMenuItems)]
        
        discoverdDevices = []
        DeviceProvider.shared.delegate = self
    }
}

// MARK: - Device Provider Delegate

extension ManagementModel: DeviceProviderDelegate {
    func discover(device: Device) {
        guard let selectedMenuId = selectedMenuId else { return }
        
        switch selectedMenuId {
            
        case manageMenuItems.first!.id:
            guard device.name.hasPrefix("BANFi Pods") else { return }
            discoverdDevices.append(device)
            
        case manageMenuItems.last!.id:
            guard device.name.hasPrefix("BANFi Transmitter") else { return }
            discoverdDevices.append(device)
            
        default: break
        }
    }
}
