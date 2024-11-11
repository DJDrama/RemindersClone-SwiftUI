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
    @State private var selectedList: MyList?
    @State private var actionSheet: MyListScreenSheets?
    
    enum MyListScreenSheets: Identifiable {
        var id: Int {
            switch self {
                
            case .newList:
                return 1
            case .editList(let myList):
                return myList.hashValue
            }
        }
        
        case newList
        case editList(MyList)
    }
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            ForEach(myLists) {myList in
                NavigationLink(value: myList) {
                    MyListCellView(myList: myList)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedList = myList
                        }
                        .onLongPressGesture(minimumDuration: 0.5, perform: {
                            actionSheet = .editList(myList)
                        })
                }
            }
            
            Button(action: {
                actionSheet = .newList
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }).listRowSeparator(.hidden)
        }
        .navigationDestination(item: $selectedList, destination: { myList in
            MyListDetailScreen(myList: myList)
        })
        .listStyle(.plain)
        .sheet(item: $actionSheet, content: { _actionSheet in
            switch _actionSheet {
            case .newList:
                NavigationStack{
                    AddMyListScreen()
                }
            case .editList(let myList):
                NavigationStack{
                    AddMyListScreen(myList: myList)
                }
            }
        })
            
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListScreen()
    }.modelContainer(previewContainer)
}


