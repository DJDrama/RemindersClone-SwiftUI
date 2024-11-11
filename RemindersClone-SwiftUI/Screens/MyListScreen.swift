//
//  MyListScreen.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI
import SwiftData

struct MyListScreen: View {
    @Query private var myLists: [MyList]
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            ForEach(myLists) {myList in
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Color.init(hex: myList.colorCode))
                    
                    Text(myList.name)
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

#Preview { @MainActor in
    NavigationStack {
        MyListScreen()
    }.modelContainer(previewContainer)
}
