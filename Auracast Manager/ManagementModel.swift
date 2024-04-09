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
    
    let broacastGroup     = MenuItem(name: "Broadcast Group", image: "rectangle.3.group")
    let transmitterConfig = MenuItem(name: "Transmitter",     image: "hifispeaker")
    let receiverConfig    = MenuItem(name: "Receiver",        image: "airpodsmax")
    
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
                if selectedMenuId == broacastGroup.id ||
                    selectedMenuId == transmitterConfig.id ||
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
        manageItems = [broacastGroup, transmitterConfig, receiverConfig]
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
    func discover(_ device: Device) {
        switch selectedMenuId {
        case broacastGroup.id:
            discoverdDevices.append(device)
            
        case transmitterConfig.id:
            guard device.name.hasPrefix("BANFi Transmitter") else { return }
            discoverdDevices.append(device)
            
        case receiverConfig.id:
            guard device.name.hasPrefix("BANFi Receiver") else { return }
            discoverdDevices.append(device)
            
        default: break
        }
    }
}

// MARK: - Device Provider

struct Device: Identifiable, Hashable {
    var id: UUID
    var name: String
    var image: String
}

fileprivate protocol DeviceProviderDelegate: AnyObject {
    func discover(_ device: Device)
}

fileprivate class DeviceProvider {
    static let shared = DeviceProvider()
    
    weak var delegate: DeviceProviderDelegate?
    
    var isRunning = false
    
    private init() {}
    
    func start() {
        isRunning = true
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(500)) {
            var index = 1
            while self.isRunning {
                if index > 20 {
                    break
                }
                let prefix = [("BANFi Transmitter", "hifispeaker"),
                              ("BANFi Receiver", "airpodsmax")].randomElement()!
                let name = "\(prefix.0) \(index)"
                let image = prefix.1
                DispatchQueue.main.async {
                    self.delegate?.discover(Device(id: UUID(), name: name, image: image))
                }
                index += 1
                usleep(600)
            }
        }
    }
    
    func stop() {
        isRunning = false
    }
}
