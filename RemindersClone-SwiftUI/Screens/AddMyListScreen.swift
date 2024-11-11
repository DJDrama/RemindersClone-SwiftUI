//
//  AddMyListScreen.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI

struct AddMyListScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var color: Color = .blue
    @State private var listName: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(color)
            
            TextField("List name", text: $listName)
                .textFieldStyle(.roundedBorder)
                .padding([.horizontal], 44)
            
            ColorPickerView(selectedColor: $color)
        }
        .navigationTitle("New List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close"){
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done"){
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddMyListScreen()
    }
}
