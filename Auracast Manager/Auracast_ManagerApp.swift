//
//  Auracast_ManagerApp.swift
//  Auracast Manager
//
//  Created by Jason on 2024/4/8.
//

import SwiftUI

@main
struct Auracast_ManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ViewCoordinator()
        }
    }
}

struct ViewCoordinator: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            ContentView()
        }else {
            SplashScreen(isActive: $isActive)
        }
    }
}

struct SplashScreen: View {
    @State private var scale = 0.7
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 220)
            }.scaleEffect(scale)
            .onAppear{
//                withAnimation(.easeIn(duration: 0.7)) {
//                    self.scale = 0.9
//                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


var isPhoneDevice: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

var isLandscape: Bool {
    return UIDevice.current.orientation.isLandscape
}
