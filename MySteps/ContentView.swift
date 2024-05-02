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
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    ProfileView()
                    ChartView()
                    AchievementsView()
                }
                .padding(.top, 20)
                .padding([.bottom, .leading, .trailing], 5)
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
