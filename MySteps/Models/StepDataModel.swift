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
        try await updateAchievementsFromCurrentMonthSteps()
        UserDefaults.standard.set(Date(), forKey: Constants.lastFetchDate)
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
    }
    
    private func currentDateRange() throws -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1, hour: 23, minute: 59, second: 59), to: startOfMonth) else {
            throw NSError(domain: "com.example.MySteps", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to calculate the current month's date range."])
        }
        return (start: startOfMonth, end: endOfMonth)
    }
    
    private func fetchCurrentMonthSteps() async throws -> [ManagedStepRecord] {
        let managedContext = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<ManagedStepRecord> = ManagedStepRecord.fetchRequest()

        let dateRange = try currentDateRange()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", dateRange.start as NSDate, dateRange.end as NSDate)

        do {
            let records = try managedContext.fetch(fetchRequest)
            return records
        } catch {
            print("Failed to fetch records for the current month: \(error)")
            throw error
        }
    }
    
    func updateAchievementsFromCurrentMonthSteps() async throws {
        let records = try await fetchCurrentMonthSteps()
        let totalSteps = records.reduce(0) { $0 + Int($1.steps) }
        await updateAchievements(totalSteps: totalSteps)
    }
    
    @MainActor
    private func updateAchievements(totalSteps: Int) {
        var newAchieve = [AchievementModel]()
        for milestone in StepsTakenMilestone.allCases {
            
            if totalSteps >= milestone.rawValue {
                let today = Date() // NOTE: the Figma design specifies that the date displayed should be on
                let achievement = AchievementModel(milestone: milestone, date: today)
                if !achievements.contains(achievement) {
                    newAchieve.append(achievement)
                }
            }
        }
        newAchieve.sort { $0.milestone.rawValue > $1.milestone.rawValue }
        achievements = newAchieve
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
