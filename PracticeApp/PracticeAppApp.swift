//
//  PracticeAppApp.swift
//  PracticeApp
//
//  Created by Manish Kumar on 24/01/25.
//

import SwiftUI
import SwiftData

@main
struct PracticeAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: TaskModel.self, inMemory: false)
        }
    }
}
