//
//  FreeServiceView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/2.
//

import SwiftUI


private struct RowData: Identifiable {
    let id = UUID()
    let title: String
    var subtitle: String
}


struct FreeServiceView: View {
    private let items = [ RowData(title: "Pods Count", subtitle: "3"),
                          RowData(title: "Hi-Fi Count", subtitle: "1")
    ]
    
    var body: some View {
        VStack {
            Image("paper_plane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .padding()
            
            Text("$0")
                .font(.system(size: 40, weight: .black))
                .frame(maxHeight: 40)
                .padding()
            
            List(items) { item in
                HStack(alignment: .center) {
                    Text(item.title)
                        .font(.system(size: 14))
                    Spacer()
                    Text(item.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 3)
            }
            .listStyle(.insetGrouped)
            .cornerRadius(12)
        }
    }
}

#Preview {
    FreeServiceView()
}
