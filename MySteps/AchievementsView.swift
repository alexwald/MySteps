//
//  AchievementsView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct AchievementsView: View {
    var achievements: [AchievementModel] = [AchievementModel(milestone: .fifteenK, date: Date()),
                                            AchievementModel(milestone: .twentyK, date: Date()),
                                            AchievementModel(milestone: .twentyFiveK, date: Date()),
                                            AchievementModel(milestone: .thirtyK, date: Date()),
                                            AchievementModel(milestone: .thirtyFiveK, date: Date()),
                                            AchievementModel(milestone: .fortyK, date: Date())
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Achievements ")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold, design: .default))
                Text("\(achievements.count)")
                    .foregroundColor(Color("steps-blue"))
                    .font(.system(size: 24, weight: .bold, design: .default))
                Spacer()
            }
    
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(achievements, id: \.self) { achievement in
                        AchievementView(model: achievement)
                    }
                }
            }
            .frame(height: 180)
        }
        .background(Color.black)  
        .edgesIgnoringSafeArea(.all)
    }
}
#Preview {
    AchievementsView()
}
