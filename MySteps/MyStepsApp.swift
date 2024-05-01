//
//  MyStepsApp.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

@main
struct MyStepsApp: App {
    let persistenceController = PersistenceController.shared
    
//    init() {
//        print("start of the app")
//    }

    var body: some Scene {
        WindowGroup {
//            ContentViewWithModel()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            ContentView()
            
        }
    }
}
