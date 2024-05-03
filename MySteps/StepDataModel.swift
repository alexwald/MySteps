//
//  StepDataModel.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import Foundation
import CoreData

class StepDataModel: ObservableObject {
    @Published var stepCounts: [StepRecord] = []
    @Published var achievements: [AchievementModel] = []

    let healthkit = HealthKitController()
    let persistenceController = PersistenceController.shared

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
        try await self.saveStepsToCoreData(stepRecords: self.stepCounts)
        UserDefaults.standard.set(Date(), forKey: Constants.lastFetchDate)
        print(self.stepCounts.description)
    }
    
    private func saveStepsToCoreData(stepRecords: [StepRecord]) async throws {
     
        let managedContext = persistenceController.container.viewContext

        // Process each StepRecord to update CoreData
        for stepRecord in stepRecords {
            let fetchRequest: NSFetchRequest<ManagedStepRecord> = ManagedStepRecord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", stepRecord.id)

            let results = try managedContext.fetch(fetchRequest)
            let stepEntity: ManagedStepRecord

            if let existingEntity = results.first {
                stepEntity = existingEntity
            } else {
                stepEntity = NSEntityDescription.insertNewObject(forEntityName: "ManagedStepRecord", into: managedContext) as! ManagedStepRecord
                stepEntity.id = stepRecord.id
            }

            stepEntity.date = stepRecord.date
            stepEntity.steps = Int64(stepRecord.steps)
        }

        try managedContext.save()
        await updateAchievements(stepRecords: stepRecords)

    }
    
    @MainActor
    private func updateAchievements(stepRecords: [StepRecord]) {
        for stepRecord in stepRecords {
            let steps = Int(stepRecord.steps)
            let date = stepRecord.date

            for milestone in StepsTakenMilestone.allCases {
                if steps >= milestone.rawValue {
                    let achievement = AchievementModel(milestone: milestone, date: date)
                    if !self.achievements.contains(achievement) {
                        self.achievements.append(achievement)
                    }
                }
            }
            self.achievements.sort { $0.milestone.rawValue > $1.milestone.rawValue }
        }
    }
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
