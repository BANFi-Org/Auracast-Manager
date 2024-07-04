//
//  BroadcastGroupView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI

struct BroadcastGroupView: View {
    
    @Binding var device: Device!
    
    @State private var isConnected = false {
        didSet {
            if isConnected {
                self.didConnected()
            } else {
                self.didDisconnected()
            }
        }
    }
    
    @State private var groupNumber: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !isConnected {
                    VStack {
                        Image(systemName: device.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(device.name)
                        Text("connecting...")
                            .font(.system(size: 12))
                            .foregroundStyle(.blue)
                        ProgressView()
                    }
                    .scaleEffect(!isConnected ? 1.0 : 0.0)
                    .animation(.linear, value: isConnected)
                    
                } else {
                    HStack {
                        Image(systemName: device.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text(device.name)
                            .font(.title)
                        
                        Spacer()
                        
                        Text("Connected")
                            .font(.system(size: 12))
                            .foregroundStyle(.blue)
                    }
                    .scaleEffect(isConnected ? 1.0 : 0.0)
                    .animation(.easeInOut, value: isConnected)
                    VStack {
                        HStack {
                            Text("Broadcast Group")
                                .font(.system(size: 22))
                                .padding()
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("SET")
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(.white)
                                    .padding(.init(top: 6, leading: 12, bottom: 6, trailing: 12))
                                    .background(.blue)
                                    .clipShape(.rect(cornerRadius: 10))
                                
                            }
                        }
                        TextField("i.e 3", text: $groupNumber)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .frame(minHeight: 30)
                            .padding()
                    }
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    Spacer()
                }
            }
            .padding()
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self.isConnected = true
                }
            }
        }
        .onChange(of: device) {
            reset()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.isConnected = true
            }
        }
    }
    
    private func reset() {
        isConnected = false
    }
    
    func didConnected() {
    }
    
    func didDisconnected() {
    }
}


#Preview {
    @State var device: Device! = .init(id: UUID(),
                                       name: "BANFi Receiver",
                                       image: "airpodsmax")
    return BroadcastGroupView(device: $device)
}
