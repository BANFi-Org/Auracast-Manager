//
//  SettingMenuView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/3.
//

import SwiftUI

struct SettingMenuView: View {
    @ObservedObject var dataModel: ManagementModel

    var body: some View {
        List(selection: $dataModel.selectedSettingId) {
            Section {
                ForEach(dataModel.functionsMenuItems, id: \.id) { item in
                    HStack {
                        Image(systemName: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                        Text(item.name)
                            .font(.system(size: 15))
                    }
                    .padding(.init(top: 3, leading: 20, bottom: 3, trailing: 0))
                }
            } header: {
                Text("Function")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Section {
                ForEach(dataModel.banfiMenuItems, id: \.id) { item in
                    HStack {
                        Image(systemName: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                        Text(item.name)
                            .font(.system(size: 15))
                    }
                    .padding(.init(top: 3, leading: 20, bottom: 3, trailing: 0))
                }
            } header: {
                Text("About")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingMenuView(dataModel: ManagementModel())
}
