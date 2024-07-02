//
//  StreamScanner.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/10.
//

import Foundation

struct ScannedStream: Identifiable, Hashable {
    var id: UUID
    var name: String
    var secure: Bool
}

class StreamScanner: ObservableObject {
    
    @Published var isRunning = false
    
    @Published var discoveredStreams: [ScannedStream] = []
    
    init() {}
    
    func start() {
        isRunning = true
        discoveredStreams.removeAll()
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(500)) {
            var data = [
                ("Airport Broadcast", false),
                ("GATE A Broadcast", false),
                ("GATE B Broadcast", false),
                ("GATE C Broadcast", false),
                ("Alex's Phone", true),
                ("Mary's Phone", true),
                ("機場廣播", false),
                ("登機門 A 廣播", false),
                ("登機門 B 廣播", false),
                ("登機門 C 廣播", false),
                ("空港放送", false),
                ("ゲート A 放送", false),
                ("ゲート B 放送", false),
                ("ゲート C 放送", false)
            ]
            
            
            while self.isRunning, !data.isEmpty {
                guard let index = (0..<data.count).randomElement() else {
                    continue
                }
                let stream = data.remove(at: index)
                let name: String = stream.0
                let secure: Bool = stream.1
                DispatchQueue.main.async {
                    self.discoveredStreams.append(ScannedStream(id: UUID(), name: name, secure: secure))
                }
                usleep(600)
            }
        }
    }
    
    func stop() {
        isRunning = false
    }
}
