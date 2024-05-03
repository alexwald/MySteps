//
//  ContentView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct ContentView: View {
    let healthkit = HealthKitController()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var stepCounts: [Date: Double] = [:]
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var logger: Logger
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView{
                    VStack {
                        ProfileView()
                        ChartView()
                            .aspectRatio(16/9, contentMode: .fit)
                            .environmentObject(logger)
                        AchievementsView()
                    }
                    .padding(.top, 20)
                    .padding([.bottom, .leading, .trailing], 5)
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    checkAndLoadData()
                }
            }
            .alert(NSLocalizedString("Error", comment: ""), isPresented: $showAlert) {
                Button(NSLocalizedString("OK", comment: ""), role: .cancel) { showAlert.toggle() }
              } message: {
                  Text(alertMessage)
              }

        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func checkAndLoadData() {
        let lastFetchDate = UserDefaults.standard.object(forKey: Constants.lastFetchDate) as? Date ?? Date.distantPast
           let calendar = Calendar.current
           if calendar.isDateInToday(lastFetchDate) {
               logger.log("Data already fetched today.", type: .info)
               return
           }
           
           Task {
               do {
                   try await healthkit.requestAuthorization()
                   stepCounts = try await self.healthkit.fetchMonthlySteps()
                   UserDefaults.standard.set(Date(), forKey: Constants.lastFetchDate)
                   print(stepCounts.description)
               } catch {
                   logger.log("Error fetching steps: \(error)", type: .error)
                   updateUIForError(error)
               }
           }
       }
    
    @MainActor
    private func updateUIForError(_ error: Error) {
        alertMessage = "\(NSLocalizedString("Failed to fetch steps: ", comment: "error when fetching HK steps"))\(error.localizedDescription)"
        showAlert.toggle()
    }
}

#Preview {
    ContentView()
        .environmentObject(Logger(subsystem: Bundle.main.bundleIdentifier ?? "MySteps", category: "General"))
//        .environment(\.locale, .init(identifier: "fr"))  // Set to French
}
