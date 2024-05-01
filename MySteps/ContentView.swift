//
//  ContentView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct ContentView: View {
    let healthkit = HealthKitController()
    @State private var stepCounts: [Date: Double] = [:]
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                ProfileView()
                AchievementsView()
            }
   
        }
        .onAppear {
            Task {
                    do {
                        let healthKitManager = HealthKitController()
                        try await healthKitManager.requestAuthorization()
                        stepCounts = try await healthKitManager.fetchMonthlySteps()
                        print(stepCounts.description)
                    } catch {
                        print("Error: \(error)")
                    }
                }
        }

    }
}

#Preview {
    ContentView()
}
