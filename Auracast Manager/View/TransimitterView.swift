//
//  TransimitterView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI

struct TransimitterView: View {
    
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
    
    @State private var isEnableRsaInput = false
    
    @State private var isEnableDigitalInput = false
    
    @State private var isEnableAirplayInput = false
    
    @State private var isEnablePoEInput = false
    
    @State private var isEnableSdcardInput = false
    
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
                    
                    
                    Spacer().frame(maxHeight: 20)
                    
                    Text("Audio Input").font(.subheadline)
                    VStack {
                        HStack {
                            Image(systemName: "cable.coaxial")
                            Toggle("RSA", isOn: $isEnableRsaInput)
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack {
                            Image(systemName: "fibrechannel")
                            Toggle("Digital", isOn: $isEnableDigitalInput)
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack {
                            Image(systemName: "airplayaudio")
                            Toggle("Airplay", isOn: $isEnableAirplayInput)
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(maxHeight: 20)
                    
                    Text("PoE Input").font(.subheadline)
                    HStack {
                        Image(systemName: "poweroutlet.type.e")
                        Toggle(isEnablePoEInput ? "Enable" : "Disable",
                               isOn: $isEnablePoEInput)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(maxHeight: 20)
                    
                    Text("SD Card").font(.subheadline)
                    VStack {
                        HStack {
                            Image(systemName: "sdcard")
                            Toggle(isEnableSdcardInput ? "Enable" : "Disable",
                                   isOn: $isEnableSdcardInput)
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack {
                            Text("Path")
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
                    }
                    .frame(maxWidth: .infinity)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.isConnected = true
                }
            }
        }
        .onChange(of: device) {
            reset()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
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
                                       name: "BANFi Transimitter",
                                       image: "hifispeaker")
    return TransimitterView(device: $device)
}

