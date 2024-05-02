//
//  ChartView.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import SwiftUI
import Charts

struct StepData: Identifiable {
    var id: Int { return day }
    let day: Int
    let steps: Int
}

struct ChartView: View {
    let stepData: [StepData] = [
        StepData(day: 1, steps: 12000),
        StepData(day: 2, steps: 15000),
        StepData(day: 3, steps: 18000),
        StepData(day: 3, steps: 25000),
        StepData(day: 4, steps: 30000),
        StepData(day: 5, steps: 50000),
        StepData(day: 6, steps: 34000),
        StepData(day: 7, steps: 12000),
        StepData(day: 8, steps: 15000),
        StepData(day: 9, steps: 18000),
        StepData(day: 10, steps: 25000),
        StepData(day: 11, steps: 30000),
        StepData(day: 12, steps: 50000),
        StepData(day: 13, steps: 34000)
      ]
    
    var maxSteps: Int {
        Int(stepData.map { $0.steps }.max() ?? 0)
     }
    
    var totalStepsThisMonth: String {
        let totalInt = stepData.reduce(0) { $0 + $1.steps }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        guard let formattedString = formatter.string(from: NSNumber(value: totalInt)) else {
            print("the input total numberof steps is invalid")
            return "0"
        }
        return formattedString
    }
    
    var latestDayOfTheCurrentMonth: Int {
        let currentDate = Date()
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: currentDate) {
            return range.upperBound - 1
        } else {
            print("could not find the latest day of the month, using a default: 30")
            return 30
        }
    }
    
    var formattedMonth: String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Steps")
                    .font(.system(size: 32, weight: .black, design: .default))
                    .foregroundColor(.white)
                Text(formattedMonth)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(String(totalStepsThisMonth))
                    .font(.system(size: 32, weight: .regular, design: .default))
                    .foregroundColor(Color("steps-green"))
                Spacer()
            }
        }.fixedSize(horizontal: false, vertical: true)
        Chart {
            ForEach(stepData) { data in
                LineMark(
                    x: .value("Day", data.day),
                    y: .value("Steps", data.steps)
                )
                .interpolationMethod(.catmullRom)

                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
            }
        }
        .padding([.bottom, .top], 15)
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom) {
                AxisValueLabel()
                    .foregroundStyle(.gray.opacity(1))
            }
        }
        .chartYAxis {
            AxisMarks(preset: .aligned, position: .trailing) {
                        AxisGridLine()
                            .foregroundStyle(.gray.opacity(1))
                AxisValueLabel()
                    .foregroundStyle(.gray.opacity(1))
            }
        }
        .chartYScale(domain: 0...maxSteps)
        .chartXScale(domain: 1...latestDayOfTheCurrentMonth)
    }
}

#Preview {
    ChartView()
}
