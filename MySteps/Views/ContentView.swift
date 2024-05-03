//
//  ContentView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @StateObject private var stepDataModel = StepDataModel()
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var logger: Logger
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack {
                        ProfileView()
                        ChartView(stepData: $stepDataModel.stepCounts)
                            .aspectRatio(16/9, contentMode: .fit)
                            .environmentObject(logger)
                        AchievementsView(achievements: $stepDataModel.achievements)
                    }
                    .padding(.top, 20)
                    .padding([.bottom, .leading, .trailing], 5)
                } 
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    Task {
                        do {
                            try await stepDataModel.checkAndLoadData()
                        } catch {
                            updateUIForError(error)
                        }
                    }
                }
            }
            .alert(LocalizedStrings.error, isPresented: $showAlert) {
                Button(LocalizedStrings.OK, role: .cancel) { showAlert.toggle() }
            } message: {
                Text(alertMessage)
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
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
}
