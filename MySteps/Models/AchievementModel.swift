//
//  AchievementModel.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import Foundation

enum StepsTakenMilestone: Int, CaseIterable {
    case fifteenK = 15000
    case twentyK = 20000
    case twentyFiveK = 25000
    case thirtyK = 30000
    case thirtyFiveK = 35000
    case fortyK = 40000
    
    var localizedString: String {
        return "\(String(self.rawValue / 1000))k \(LocalizedStrings.steps)"
    }
}

struct AchievementModel: Hashable {
    let milestone: StepsTakenMilestone
    let date: Date
    
    var imageName: String {
        switch self.milestone {
           case .fifteenK:
               return "achievement-15k"
           case .twentyK:
               return "achievement-20k"
           case .twentyFiveK:
               return "achievement-25k"
           case .thirtyK:
               return "achievement-30k"
           case .thirtyFiveK:
               return "achievement-35k"
           case .fortyK:
               return "achievement-40k"
           }
       }
}
