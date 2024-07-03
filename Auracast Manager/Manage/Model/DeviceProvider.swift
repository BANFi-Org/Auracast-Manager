//
//  DeviceProvider.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/10.
//

import Foundation

struct Device: Identifiable, Hashable {
    var id: UUID
    var name: String
    var image: String
}

protocol DeviceProviderDelegate: AnyObject {
    func discover(device: Device)
}

class DeviceProvider {
    static let shared = DeviceProvider()
    
    weak var delegate: DeviceProviderDelegate?
    
    var isRunning = false
    
    private var devices: [(name: String, image: String)] = []
    
    private init() {}
    
    func start() {
        isRunning = true
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(500)) {
            if self.devices.isEmpty {
                var count = 0
                while true {
                    if count > 19 {
                        break
                    }
                    let prefix = [("BANFi Transmitter", "hifireceiver"),
                                  ("BANFi Pods", "airpodsmax")].randomElement()!
                    let name = "\(prefix.0) \(count+1)"
                    let image = prefix.1
                    self.devices.append((name, image))
                    count += 1
                }
            }
            var index = 0
            while self.isRunning {
                if index >= self.devices.count {
                    break
                }
                let name = self.devices[index].name
                let image =  self.devices[index].image
                
                DispatchQueue.main.async {
                    self.delegate?.discover(device: Device(id: UUID(), name: name, image: image))
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
