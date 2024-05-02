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
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black // Set the background color

        let customFont = UIFont.systemFont(ofSize: 24, weight: .black)
        appearance.titleTextAttributes = [.font: customFont, .foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.font: customFont, .foregroundColor: UIColor.white]
           
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UIWindow.appearance().backgroundColor = .black
    }

    var body: some Scene {
        WindowGroup {
//            ContentViewWithModel()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            ContentView()
        }
    }
}
