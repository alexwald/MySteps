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
    @Binding var stepData: [StepRecord]
    @EnvironmentObject var logger: Logger
    
    var maxSteps: Int {
        Int(stepData.map { $0.steps }.max() ?? 0)
     }
    
    var totalStepsThisMonth: String {
        let totalInt = stepData.reduce(0) { $0 + $1.steps }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        guard let formattedString = formatter.string(from: NSNumber(value: totalInt)) else {
            logger.log("the input total numberof steps is invalid", type: .error)
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
            logger.log("could not find the latest day of the month, using a default: 30", type: .error)
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
                Text("Steps", comment: "label for step count")
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
                    x: .value("Day", Calendar.current.component(.day, from: data.date)),
                    y: .value("Steps", data.steps)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(LinearGradient(gradient: 
                                                    Gradient(colors: [Color("steps-green"), Color("steps-blue")]),
                                                startPoint: .top, endPoint: .bottom))
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
        // NOTE: the product spec said to set the y-axis upper limit to the total sum of steps of the month,
        // but that makes no sense; the upper domain limit should be the most steps achieved on any given day
        .chartYScale(domain: 0...maxSteps)
        .chartXScale(domain: 1...latestDayOfTheCurrentMonth)
    }
}

//#Preview {
//    ChartView(stepCounts: StepDataModel.preview)
//}
