//
//  ReminderListView.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/12/24.
//

import SwiftUI

struct ReminderListView: View {
    let reminders: [Reminder]
    @Environment(\.modelContext) private var context
    @State private var selectedReminder: Reminder?=nil
    @State private var showReminderEditScreen: Bool = false
    
    private let delay = Delay()
    
    private func deleteReminder(_ indexSet: IndexSet) {
        guard let index = indexSet.last else { return }
        let reminder = reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        List{
            ForEach(reminders) { reminder in
                ReminderCellView(reminder: reminder) { event in
                    switch event {
                    case .onChecked(let reminder, let checked):
                        delay.cancel()
                        delay.performWork {
                            reminder.isCompleted = checked
                        }
                    case .onSelect(let reminder):
                        selectedReminder = reminder
                    }
                }
            }.onDelete(perform: deleteReminder)
        }.sheet(item: $selectedReminder, content: { selectedreminder in
            NavigationStack{
                ReminderEditScreen(reminder: selectedreminder)
            }
        })
    }
}
