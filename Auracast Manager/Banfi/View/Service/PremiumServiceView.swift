//
//  PremiumServiceView.swift
//  Auracast Manager
//
//  Created by Jason on 2024/7/2.
//

import SwiftUI

private struct RowData: Identifiable {
    var id = UUID()
    var type: RowType
    var title: String
    var valuePrefix: String
    var value: String
}

private enum RowType {
    case label
    case editField
}

private struct RowLabelView: View {
    @Binding var data: RowData
    
    var body: some View {
        HStack(alignment: .center) {
            Text(data.title)
                .font(.system(size: 14))
            Spacer()
            Text(data.value)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 3)
    }
}

private struct RowEditFieldView: View {
    @Binding var data: RowData
    let onValueChange: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(data.title)
                .font(.system(size: 14))
            Spacer()
            Text(data.valuePrefix)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            TextField("Enter...", text: $data.value)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(maxWidth: 80)
                .onChange(of: data.value) {  _, _ in
                    onValueChange()
                }
        }
        .padding(.vertical, 3)
    }
}


struct PremiumServiceView: View {
    @State private var setSection: [RowData] = [
        RowData(type: .label, title: "Pods", valuePrefix: "", value: "3"),
        RowData(type: .label, title: "Hi-Fi", valuePrefix: "", value: "1")
    ]
    
    @State private var estimateSection: [RowData] = [
        RowData(type: .editField, title: "Set Count", valuePrefix: "", value: "1"),
        RowData(type: .editField, title: "Cost per a set", valuePrefix: "$", value: "400")
    ]
    
    @State private var totalCost: Int = 3000
    
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        VStack {
            Image("diamond")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .padding()
            
            Text("$\(String(format: "%d", totalCost))")
                .font(.system(size: 40, weight: .black))
                .frame(maxHeight: 40)
                .padding()
            
            List{
                Section(header: Text("Detail per a Set").font(.system(size: 17, weight: .bold)).foregroundStyle(.black)) {
                    ForEach($setSection) { $item in
                        if item.type == .label {
                            RowLabelView(data: $item)
                        }
                    }
                }
                Section(header: Text("Estimation").font(.system(size: 17, weight: .bold)).foregroundStyle(.black)) {
                    ForEach($estimateSection) { $item in
                        if item.type == .label {
                            RowLabelView(data: $item)
                        } else if item.type == .editField {
                            RowEditFieldView(data: $item, onValueChange: calculateTotalCost)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.blue)
            .cornerRadius(12)
            .onTapGesture {
                hideKeyboard()
            }
        }
//        .padding(.bottom, keyboard.currentHeight)
//        .animation(.easeOut(duration: 0.16), value: keyboard.currentHeight)
    }
    
    private func calculateTotalCost() {
        let setCount = Int(estimateSection.first(where: { $0.title == "Set Count" })?.value ?? "0") ?? 0
        let costPerSet = Int(estimateSection.first(where: { $0.title == "Cost per a set" })?.value ?? "0") ?? 0
        totalCost = 3000 + setCount * costPerSet
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    PremiumServiceView()
}
