//
//  AchievementsView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct AchievementsView: View {
    @Binding var achievements: [AchievementModel]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Achievements ", comment: "label displaying the achievements count")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold, design: .default))
                Text("\(achievements.count)")
                    .foregroundColor(Color("steps-blue"))
                    .font(.system(size: 24, weight: .bold, design: .default))
                Spacer()
            }
    
            if achievements.isEmpty {
                VStack {
                    Image("no-steps")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 94, height: 94)
                    
                    Text("No achievements yet", comment: "label for no achievements")
                        .font(.system(size: 21, weight: .heavy, design: .default))
                        .foregroundColor(.white)
                    
                    Text("Take the first step!", comment: "subtitle for no achievements")
                        .font(.system(size: 21, weight: .semibold, design: .default))
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(achievements, id: \.self) { achievement in
                            NavigationLink(destination: AchievementDetailView(model: achievement)) {
                                AchievementView(model: achievement)
                            }
                        }
                    }
                }
                .frame(height: 180)
            }
        }
        .background(Color.black)  
        .edgesIgnoringSafeArea(.all)
    }
}
