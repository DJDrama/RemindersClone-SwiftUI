//
//  MyListScreen.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI
import SwiftData

enum ReminderStatsType: Int, Identifiable {
    var id: Int {
        self.rawValue
    }
    var title: String {
        switch self {
            
        case .today:
            "Today"
        case .scheduled:
            "Scheduled"
        case .all:
            "All"
        case .completed:
            "Completed"
        }
    }
    case today
    case scheduled
    case all
    case completed
}

struct MyListScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isPresented: Bool = false
    @State private var selectedList: MyList?
    @State private var actionSheet: MyListScreenSheets?
    @State private var reminderStatsType: ReminderStatsType?
    @State private var search: String = ""
    
    @Query private var myLists: [MyList]
    @Query private var reminders: [Reminder]
    
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
    
    private var inCompleteReminders: [Reminder] {
        reminders.filter { reminder in !reminder.isCompleted }
    }
    
    private var todayReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else {
                return false
            }
            return reminderDate.isToday && !$0.isCompleted
        }
    }
    
    private var scheduledReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }
    
    private var completedReminders: [Reminder] {
        reminders.filter{
            $0.isCompleted
        }
    }
    
    private var searchResults: [Reminder] {
        reminders.filter {
            $0.title.lowercased().contains(search.lowercased())
            && !$0.isCompleted
        }
    }
    
    private func deleteList(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let myList = myLists[index]
        
        // delete it
        context.delete(myList)
    }
    
    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
        case .today:
            return todayReminders
        case .scheduled:
            return scheduledReminders
        case .all:
            return inCompleteReminders
        case .completed:
            return completedReminders
        }
    }
    
    var body: some View {
        List {
            VStack {
                HStack {
                    ReminderStatsView(icon: "calendar", title: "Today", count: todayReminders.count)
                        .onTapGesture {
                            reminderStatsType = .today
                        }
                    ReminderStatsView(icon: "calendar.circle.fill", title: "Scheduled", count: scheduledReminders.count)
                        .onTapGesture {
                            reminderStatsType = .scheduled
                        }
                }
                HStack {
                    ReminderStatsView(icon: "tray.circle.fill", title: "All", count: inCompleteReminders.count)
                        .onTapGesture {
                            reminderStatsType = .all
                        }
                    ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: completedReminders.count)
                        .onTapGesture {
                            reminderStatsType = .completed
                        }
                }
            }
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
            }.onDelete(perform: deleteList)
            
            Button(action: {
                actionSheet = .newList
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }).listRowSeparator(.hidden)
        }
        .searchable(text: $search)
        .overlay(alignment: .center, content: {
            if !search.isEmpty {
                ReminderListView(reminders: searchResults)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .dark ? .black : .white)
            }
        })
        .navigationTitle("My Lists")
        .navigationDestination(item: $selectedList, destination: { myList in
            MyListDetailScreen(myList: myList)
        })
        .navigationDestination(item: $reminderStatsType, destination: { reminderStatsType in
            ReminderListView(reminders: reminders(for: reminderStatsType))
                .navigationTitle(reminderStatsType.title)
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

#Preview("Light Mode") { @MainActor in
    NavigationStack {
        MyListScreen()
    }.modelContainer(previewContainer)
}



#Preview("Dark Mode") { @MainActor in
    NavigationStack {
        MyListScreen()
    }.modelContainer(previewContainer)
        .environment(\.colorScheme, .dark)
}

