//
//  RemindersClone_SwiftUIApp.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import SwiftUI

@main
struct RemindersClone_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MyListScreen()
            }.modelContainer(for: MyList.self)
        }
    }
}
