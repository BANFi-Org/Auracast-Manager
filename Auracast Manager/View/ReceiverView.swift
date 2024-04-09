//
//  ReceiverView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/9.
//

import SwiftUI

struct ReceiverView: View {
    
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
                    
                    Text("Volume").font(.subheadline)
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "airpodpro.left")
                                Text("Left")
                            }
                            HStack {
                                Image(systemName: "airpodpro.right")
                                Text("Right")
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
                    
                    Spacer().frame(maxHeight: 20)
                    
                    Text("Balance").font(.subheadline)
                    HStack {
                        Image(systemName: "airpodpro.left")
                        Text("Left")
                        Spacer().frame(maxWidth: 12)
                        VStack {
                            Text("\(String(format: "%.0f", balancePercent))%")
                            Slider(value: $balancePercent, in: -50...50)
                                .tint(.gray.opacity(0.3))
                        }
                        Spacer().frame(maxWidth: 12)
                        Text("Right")
                        Image(systemName: "airpodpro.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 0.33)
                    }
                    
                    Spacer().frame(maxHeight: 20)
                    
                    Text("Multiple Subscription").font(.subheadline)
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
                                       name: "BANFi Receiver",
                                       image: "airpodsmax")
    return ReceiverView(device: $device)
}
