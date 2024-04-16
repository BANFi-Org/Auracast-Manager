//
//  ManagementModel.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI


class ManagementModel: ObservableObject {
    
    @Published var manageItems: [MenuItem]
    
    @Published var settingItems: [MenuItem]
    
    @Published var subMenuItems: [MenuItem]
    
    @Published var discoverdDevices: [Device]
    
    let receiverConfig    = MenuItem(name: "Pods",  image: "airpodsmax")
    
    let transmitterConfig = MenuItem(name: "Hi-Fi", image: "hifispeaker")
    
    let settings = MenuItem(name: "Settings", image: "gear")
    
    let settingsMenuItems = [MenuItem(name: "Preference", image: "checklist"),
                             MenuItem(name: "Magic Lab",  image: "lasso.badge.sparkles"),
                             MenuItem(name: "Share",      image: "square.and.arrow.up"),
                             MenuItem(name: "About",      image: "exclamationmark.circle")]
    
    @Published var selectedMenuId: MenuItem.ID? {
        didSet {
            guard selectedMenuId != oldValue else {
                return
            }
            selectedDevice = nil
            DeviceProvider.shared.stop()
            discoverdDevices.removeAll()
            if let selectedMenuId = selectedMenuId {
                if selectedMenuId == transmitterConfig.id ||
                    selectedMenuId == receiverConfig.id {
                    DeviceProvider.shared.start()
                }
            }
        }
    }
    
    @Published var selectedDevice: Device?
    
    var isScanning: Bool {
        return DeviceProvider.shared.isRunning
    }
    
    init() {
        manageItems = [receiverConfig, transmitterConfig]
        settingItems = [settings]
        subMenuItems = []
        discoverdDevices = []
        DeviceProvider.shared.delegate = self
    }
    
    func getSelectedMenu() -> MenuItem? {
        guard let id = selectedMenuId else {
            return nil
        }
        let menus = [manageItems, settingItems, subMenuItems]
        for menu in menus {
            if let item = menu.first(where: { $0.id == id }) {
                return item
            }
        }
        return nil
    }
}

// MARK: - Device Provider Delegate

extension ManagementModel: DeviceProviderDelegate {
    func discover(device: Device) {
        switch selectedMenuId {
            
        case transmitterConfig.id:
            guard device.name.hasPrefix("BANFi Hi-Fi") else { return }
            discoverdDevices.append(device)
            
        case receiverConfig.id:
            guard device.name.hasPrefix("BANFi Pods") else { return }
            discoverdDevices.append(device)
            
        default: break
        }
    }
}
