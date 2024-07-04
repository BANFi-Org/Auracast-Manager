//
//  BanfiPartnersView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/2.
//

import SwiftUI

struct UnderlinedText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .underline()
    }
}

extension View {
    func underlined() -> some View {
        self.modifier(UnderlinedText())
    }
}

struct BanfiPartnersView: View {
    var body: some View {
//        ScrollView {
            VStack {
                Image("banfi_semi")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(maxWidth: 200)
                Text("https://banfiww.com/")
                    .font(.system(size: 13))
                    .underlined()
                    .foregroundStyle(.blue)
            }
            .padding()
            .onTapGesture {
                openURL("https://banfiww.com/")
            }
//        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    BanfiPartnersView()
}
