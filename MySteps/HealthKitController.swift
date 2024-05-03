//
//  HealthKitController.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import HealthKit

class HealthKitController {
    var healthStore: HKHealthStore?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization() async throws {
        guard let healthStore = self.healthStore else {
            throw NSError(domain: "com.example.HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."])
        }

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        try await healthStore.requestAuthorization(toShare: [], read: [stepType])
    }

    func fetchMonthlySteps() async throws -> [Date: Double] {
        guard let healthStore = self.healthStore,
              let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw NSError(domain: "com.example.HealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to access step count data."])
        }

        let now = Date()
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: now))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: startOfMonth,
                                                intervalComponents: interval)

        return try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    var data: [Date: Double] = [:]
                    result.enumerateStatistics(from: startOfMonth, to: endOfMonth) { statistics, _ in
                        let date = statistics.startDate
                        let steps = statistics.sumQuantity()?.doubleValue(for: HKUnit.count())
                        data[date] = steps

                    }
                    continuation.resume(returning: data)
                }
            }
            healthStore.execute(query)
        }
    }
}
