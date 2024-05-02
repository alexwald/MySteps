//
//  AchievementView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct AchievementView: View {
    var model: AchievementModel
    
    var body: some View {
        VStack {
            Image(model.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 116, height: 116)
                .clipShape(Circle())
            Text("\(model.milestone.rawValue)")
                .font(.system(size: 16, weight: .heavy, design: .default))
                .foregroundColor(.white)
            Text(model.date.achievementFormat)
                .font(.system(size: 13, weight: .semibold, design: .default))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    AchievementView(model: AchievementModel(milestone: .thirtyK, date: Date()))
}

