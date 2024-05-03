//
//  StepDataModel.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import Foundation

class StepDataModel: ObservableObject {
    @Published var stepCounts: [StepRecord] = []
   
    @MainActor
    func refreshWith(stepCounts: [Date: Double] = [:]) {
        let newSteps = stepCounts.map { date, steps -> StepRecord in
            return StepRecord(date: date, steps: Int(steps))
        }
        .sorted { $0.date < $1.date }

        self.stepCounts = newSteps
    }
}

extension StepDataModel {
//    static var preview: StepDataModel {
//        let sampleData: [Date: Double] = [
//            Date().addingTimeInterval(-86400 * 2): 15000, // 2 days ago
//            Date().addingTimeInterval(-86400): 22000,     // 1 day ago
//            Date(): 11500                                 // today
//        ]
//        
//        let model = StepDataModel()
//        model.refreshWith(stepCounts: sampleData)
//        return model
//    }
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
