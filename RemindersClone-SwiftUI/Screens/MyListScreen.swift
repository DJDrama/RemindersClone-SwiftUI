//
//  MyListScreen.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI

struct MyListScreen: View {
    let myLists = ["Reminders", "Groceries", "Entertainment"]
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            ForEach(myLists, id: \.self) {myList in
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .font(.system(size: 32))
                    Text(myList)
                }
            }
            
            Button(action: {
                isPresented = true
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }).listRowSeparator(.hidden)
        }.listStyle(.plain)
            .sheet(isPresented: $isPresented, content: {
                NavigationStack{
                    AddMyListScreen()
                }
            })
    }
}

#Preview {
    NavigationStack {
        MyListScreen()
    }
}
