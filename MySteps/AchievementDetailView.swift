//
//  AchievementDetailView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct AchievementDetailView: View {
    var model: AchievementModel
    
    var body: some View {
        ZStack {
            VStack {
                Image(model.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 207, height: 207)
                    .clipShape(Circle())
                Text("\(model.milestone.rawValue)")
                    .font(.system(size: 32, weight: .heavy, design: .default))
                    .foregroundColor(.white)
                
                Text("\(model.date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .foregroundColor(.gray)
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    AchievementDetailView(model: AchievementModel(milestone: .thirtyK, date: Date()))
}
