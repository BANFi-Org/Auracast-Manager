//
//  BanfiPartnersView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/2.
//

import SwiftUI

struct BanfiPartnersView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("banfi_semi")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                    .padding()
                Spacer()
                Image("partner_coordiwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                    .padding()

            }
            .padding()
        }
    }
}

#Preview {
    BanfiPartnersView()
}
