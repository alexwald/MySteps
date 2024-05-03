//
//  StepDataModel.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import Foundation

class StepDataModel: ObservableObject {
    @Published var stepCounts: [StepRecord] = []
    let healthkit = HealthKitController()
    
    @MainActor
    private func refreshWith(stepCounts: [Date: Double] = [:]) {
        let newSteps = stepCounts.map { date, steps -> StepRecord in
            return StepRecord(date: date, steps: Int(steps))
        }
        .sorted { $0.date < $1.date }

        self.stepCounts = newSteps
    }
    
    func checkAndLoadData() async throws {
        try await healthkit.requestAuthorization()
        let healthKitSteps = try await self.healthkit.fetchMonthlySteps()
        await self.refreshWith(stepCounts: healthKitSteps)
        UserDefaults.standard.set(Date(), forKey: Constants.lastFetchDate)
        print(self.stepCounts.description)
    }
}

extension StepDataModel {

}

struct StepRecord: Identifiable {
    // for ID purposes
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()

    var id: String {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        if let normalizedDate = Calendar.current.date(from: dateComponents) {
            return StepRecord.dateFormatter.string(from: normalizedDate)
        }
        return ""
    }
    
    let date: Date
    var steps: Int
}
