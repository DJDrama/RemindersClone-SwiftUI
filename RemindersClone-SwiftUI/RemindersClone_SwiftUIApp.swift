//
//  RemindersClone_SwiftUIApp.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI
import UserNotifications

@main
struct RemindersClone_SwiftUIApp: App {
    
    init(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                 
//            } else {
//                
//            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MyListScreen()
            }.modelContainer(for: MyList.self)
        }
    }
}
