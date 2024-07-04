//
//  ProjectBaseServiceView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/2.
//

import SwiftUI


private struct SectionData: Identifiable {
    let id = UUID()
    let title: String
    var rows: [RowData]
    
    static func == (lhs: SectionData, rhs: SectionData) -> Bool {
        return lhs.id == rhs.id
    }
}

private struct RowData: Identifiable {
    let id = UUID()
    let title: String
    var subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

struct ProjectBaseServiceView: View {
    @State private var selectIndexPath: IndexPath = .init(row: 0, section: 0)
    
    private var sections = [
        SectionData(title: "100 m²", rows: [
            RowData(title: "30 Pods, 3 Hi-Fi", subtitle: "13000"),
            RowData(title: "40 Pods, 4 Hi-Fi", subtitle: "15000"),
            RowData(title: "50 Pods, 5 Hi-Fi", subtitle: "17000")
        ]),
        SectionData(title: "200 m²", rows: [
            RowData(title: "30 Pods, 6 Hi-Fi", subtitle: "30000"),
            RowData(title: "40 Pods, 8 Hi-Fi", subtitle: "33000"),
            RowData(title: "50 Pods, 10 Hi-Fi", subtitle: "37000")
        ]),
        SectionData(title: "300 m²", rows: [
            RowData(title: "30 Pods, 9 Hi-Fi", subtitle: "45000"),
            RowData(title: "40 Pods, 12 Hi-Fi", subtitle: "51000"),
            RowData(title: "50 Pods, 15 Hi-Fi", subtitle: "57000")
        ])
    ]
    
    var body: some View {
        VStack {
            Image("rocket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .padding()
            
            Text("$\(sections[selectIndexPath.section].rows[selectIndexPath.row].subtitle)")
                .font(.system(size: 40, weight: .black))
                .frame(maxHeight: 40)
                .padding()
            
            List {
                ForEach(sections.indices, id: \.self) { s in
                    Section(header: Text(sections[s].title).font(.system(size: 17, weight: .bold)).foregroundStyle(.black)) {
                        ForEach(sections[s].rows.indices, id: \.self) { r in
                            HStack(alignment: .center) {
                                Text(sections[s].rows[r].title)
                                    .font(.system(size: 14))
                                Spacer()
                                Text("$\(sections[s].rows[r].subtitle)")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                if selectIndexPath.section == s,
                                   selectIndexPath.row == r {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 3)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectIndexPath = IndexPath(row: r, section: s)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.yellow)
            .cornerRadius(12)
        }
    }
}


#Preview {
    ProjectBaseServiceView()
}
