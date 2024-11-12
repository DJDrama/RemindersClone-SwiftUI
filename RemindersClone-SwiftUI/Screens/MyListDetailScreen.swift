//
//  MyListDetailScreen.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI
import SwiftData

struct MyListDetailScreen: View {
    let myList: MyList
    @State private var title: String = ""
    @State private var isNewReminderAlertPresented: Bool = false
    @State private var selectedReminder: Reminder?
    @State private var showReminderEditScreen: Bool = false
    
    @Environment(\.modelContext) private var context
    
    private let delay = Delay(seconds: 1)
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myList.reminders.append(reminder)
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        return reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let reminder = myList.reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        VStack {
            ReminderListView(reminders: myList.reminders.filter { !$0.isCompleted })
            Spacer()
            Button(action: {
                isNewReminderAlertPresented = true
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reminder")
                }
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(myList.name)
        .alert("New Reminder", isPresented: $isNewReminderAlertPresented) {
            TextField("", text: $title)
            Button("Cancel", role: .cancel){
                
            }
            Button("Done"){
                saveReminder()
                title = ""
            }//.disabled(!isFormValid) <-- bug in swiftui?
        }
        .sheet(isPresented: $showReminderEditScreen, content: {
            if let selectedReminder {
                NavigationStack {
                    ReminderEditScreen(reminder: selectedReminder)
                }
            }
        })
    }
}

// only for preview
struct MyListDetailScreenContainer: View {
    
    @Query private var myLists: [MyList]
    
    var body: some View {
        MyListDetailScreen(myList: myLists[0])
    }
}

#Preview { @MainActor in
    NavigationStack{
        MyListDetailScreenContainer()
    }.modelContainer(previewContainer)
}
