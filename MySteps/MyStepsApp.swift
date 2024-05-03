//
//  MyStepsApp.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

@main
struct MyStepsApp: App {
    @StateObject private var logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "MySteps", category: "General")

    init() {
        configureAppearance()
    }
    
    private func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black

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
                .environmentObject(logger)
        }
    }
}
