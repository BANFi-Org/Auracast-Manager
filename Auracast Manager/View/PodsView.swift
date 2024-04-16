//
//  PodsView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI

struct PodsView: View {
    
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
    
    @State private var leftVolumePercent: Float = 100
    
    @State private var rightVolumePercent: Float = 100
    
    @State private var balancePercent: Float = 0
    
    @State private var isEnableMultipleSub: Bool = false
    
    @ObservedObject private var streamScanner = StreamScanner()
    
    @State private var selectedStream: ScannedStream?
    
    @State private var jointStream: Bool = false
    
    @State private var isShowingPasswordAlert: Bool = false
    
    @State private var securePassword: String = ""
    
    @State private var disableOkButton: Bool = false
    
    var body: some View {
        if !isConnected {
            VStack(alignment: .center) {
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
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.isConnected = true
                    self.streamScanner.start()
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
                    
                    HStack {
                        Text("Broadcast").font(.subheadline)
                        Spacer()
                        if streamScanner.isRunning {
                            ProgressView()
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 12))
                        }
                        if jointStream, let stream = selectedStream {
                            Button(action: {
                                selectedStream = nil
                                streamScanner.start()
                            }) {
                                Text(stream.name)
                                Image(systemName: "waveform.slash")
                            }.padding(.init(top: 0, leading: 0, bottom: 0, trailing: 12))
                        }
                    }.frame(minHeight: 40)
                    List(selection: $selectedStream) {
                        ForEach(streamScanner.discoveredStreams, id: \.self) { stream in
                            HStack {
                                Text(stream.name)
                                Spacer()
                                if jointStream && selectedStream?.id == stream.id {
                                    Image(systemName: "waveform")
                                }
                                if stream.secure {
                                    Image(systemName: "lock.fill")
                                }
                            }
                            .listRowBackground(
                                selectedStream?.id == stream.id ?
                                Capsule()
                                    .fill(Color.gray.opacity(0.3))
                                    .padding(2)
                                : nil
                            )
                        }
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: .infinity, minHeight: 230)
                    .padding(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    .onChange(of: selectedStream, { oldValue, newValue in
                        changeSelectStream(old: oldValue, new: newValue)
                    })
                    .onChange(of: securePassword, { oldValue, newValue in
                        disableOkButton = newValue.isEmpty
                    })
                    .alert("Password",
                           isPresented: $isShowingPasswordAlert,
                           presenting: selectedStream,
                           actions: { stream in
                        SecureField("Password", text: $securePassword)
                        Button("OK", action: {
                            donePassword()
                        }).disabled(disableOkButton)
                        Button("Cancel", role: .cancel) {
                            selectedStream = nil
                            streamScanner.start()
                        }
                    },
                           message: { stream in
                        Text(stream.name)
                    })
                    
                    Spacer().frame(minHeight: 22)
                    HStack {
                        Text("Volume").font(.subheadline)
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "speaker.slash")
                                .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 12))
                        }
                    }.frame(minHeight: 40)
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "airpodpro.left")
                                Text("L")
                                    .font(.system(size: 15, weight: .black))
                            }
                            HStack {
                                Image(systemName: "airpodpro.right")
                                Text("R")
                                    .font(.system(size: 15, weight: .black))
                            }
                        }
                        Spacer().frame(maxWidth: 12)
                        VStack {
                            Slider(value: $leftVolumePercent, in: 0...100)
                            Slider(value: $rightVolumePercent, in: 0...100)
                        }
                        Spacer().frame(maxWidth: 12)
                        VStack {
                            Text("\(String(format: "%.0f", leftVolumePercent))%")
                            Text("\(String(format: "%.0f", rightVolumePercent))%")
                        }
                        .frame(maxWidth: 60)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(minHeight: 22)
                    HStack {
                        Text("Balance").font(.subheadline)
                        Spacer()
                    }.frame(minHeight: 40)
                    HStack {
                        Image(systemName: "airpodpro.left")
                        Text("L")
                            .font(.system(size: 15, weight: .black))
                        Spacer().frame(maxWidth: 12)
                        VStack {
                            Text("\(String(format: "%.0f", balancePercent))%")
                            Slider(value: $balancePercent, in: -50...50)
                                .tint(.gray.opacity(0.3))
                        }
                        Spacer().frame(maxWidth: 12)
                        Text("R")
                            .font(.system(size: 15, weight: .black))
                        Image(systemName: "airpodpro.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(minHeight: 22)
                    HStack {
                        Text("Multiple Subscription").font(.subheadline)
                        Spacer()
                    }.frame(minHeight: 40)
                    VStack {
                        Toggle(isEnableMultipleSub ? "Enable" : "Disable",
                               isOn: $isEnableMultipleSub)
                        Spacer().frame(maxHeight: 20)
                        HStack {
                            Text("Max Subscription Count")
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
                }
                .padding()
            }
            .onChange(of: device) {
                reset()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.isConnected = true
                    self.streamScanner.start()
                }
            }
        }
    }
    
    private func changeSelectStream(old: ScannedStream?, new: ScannedStream?) {
        jointStream = false
        securePassword = ""
        isShowingPasswordAlert = false
        if let stream = new {
            if stream.secure {
                isShowingPasswordAlert = true
            } else {
                jointStream = true
            }
            streamScanner.stop()
        }
    }
    
    private func donePassword() {
        guard let stream = selectedStream, stream.secure,
              !securePassword.isEmpty else {
            selectedStream = nil
            streamScanner.start()
            return
        }
        jointStream = true
    }
    
    private func reset() {
        isConnected = false
        jointStream = false
        securePassword = ""
        isShowingPasswordAlert = false
        streamScanner.stop()
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
    return PodsView(device: $device)
}
