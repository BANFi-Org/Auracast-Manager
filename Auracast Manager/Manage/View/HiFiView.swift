//
//  HiFiView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI

struct HiFiView: View {
    
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
    
    @State private var delayTime: Float = 0
    
    var body: some View {
        if !isConnected {
            VStack {
                Image(systemName: device.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(device.name)
                Image("bt_logo_holo_12_gray")
                    .frame(maxHeight: 20)
                ProgressView()
            }
            .scaleEffect(!isConnected ? 1.0 : 0.0)
            .animation(.linear, value: isConnected)
            .padding()
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self.isConnected = true
                }
            }
            
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: device.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text(device.name)
                            .font(.title)
                        
                        Spacer()
                        
                        Image("bt_logo_holo_12")
                            .frame(maxHeight: 20)
                    }
                    .scaleEffect(isConnected ? 1.0 : 0.0)
                    .animation(.easeInOut, value: isConnected)
                    
                    Spacer().frame(minHeight: 22)
                    HStack {
                        Text("Audio Input").font(.subheadline)
                        Spacer()
                    }.frame(minHeight: 40)
                    VStack {
                        HStack {
                            Image(systemName: "cable.coaxial")
                                .font(.system(size: 14))
                            Toggle("RSA", isOn: $isEnableRsaInput)
                                .font(.system(size: 14))
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack {
                            Image(systemName: "fibrechannel")
                                .font(.system(size: 14))
                            Toggle("Digital", isOn: $isEnableDigitalInput)
                                .font(.system(size: 14))
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack {
                            Image(systemName: "airplayaudio")
                                .font(.system(size: 14))
                            Toggle("Airplay", isOn: $isEnableAirplayInput)
                                .font(.system(size: 14))
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack {
                            Image(systemName: "poweroutlet.type.e")
                                .font(.system(size: 14))
                            Toggle("PoE", isOn: $isEnablePoEInput)
                                .font(.system(size: 14))
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(minHeight: 22)
                    HStack {
                        Text("Delay").font(.subheadline)
                        Spacer()
                    }.frame(minHeight: 40)
                    VStack {
                        HStack {
                            Image(systemName: "slowmo")
                                .font(.system(size: 14))
                            Spacer()
                            Slider(value: $delayTime, in: 0...1000)
                            Spacer().frame(maxWidth: 12)
                            Text("\(String(format: "%.0f ms", delayTime))")
                                .frame(minWidth: 80)
                                .font(.system(size: 14))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(minHeight: 22)
                    HStack {
                        Text("SD Card").font(.subheadline)
                        Spacer()
                    }.frame(minHeight: 40)
                    VStack {
                        HStack {
                            Image(systemName: "sdcard")
                                .font(.system(size: 14))
                            Toggle("", isOn: $isEnableSdcardInput)
                                .font(.system(size: 14))
                        }
                        .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                        VStack {
                            HStack {
                                Text("Path")
                                    .font(.system(size: 14))
                                Spacer()
                                Button(action: {
                                    
                                }) {
                                    Text("SET")
                                        .font(.system(size: 14, weight: .black))
                                        .foregroundColor(.white)
                                        .padding(.init(top: 6, leading: 12, bottom: 6, trailing: 12))
                                        .background(isEnableSdcardInput ? .blue : .gray)
                                        .clipShape(.rect(cornerRadius: 10))
                                    
                                }
                            }
                            TextField("i.e /root", text: $groupNumber)
                                .font(.system(size: 14))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .frame(minHeight: 30)
                        }
                        .disabled(!isEnableSdcardInput)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                }
                .padding()
                
            }
            .onChange(of: device) {
                reset()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    self.isConnected = true
                }
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
    return HiFiView(device: $device)
}

