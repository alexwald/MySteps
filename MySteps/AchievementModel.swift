//
//  AchievementModel.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import Foundation

enum StepsTakenMilestone: String {
    case fifteenK = "15k Steps"
    case twentyK = "20k Steps"
    case twentyFiveK = "25k Steps"
    case thirtyK = "30k Steps"
    case thirtyFiveK = "35k Steps"
    case fortyK = "40k Steps"
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
