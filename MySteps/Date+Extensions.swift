//
//  Date+Extensions.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import Foundation

extension Date {
    var achievementFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}
