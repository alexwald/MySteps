//
//  AchievementDetailView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct AchievementDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var model: AchievementModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Image(model.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 207, height: 207)
                    .clipShape(Circle())
                Text("\(model.milestone.localizedString)")
                    .font(.system(size: 32, weight: .heavy, design: .default))
                    .foregroundColor(.white)
                
                Text(model.date.achievementFormat)
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .foregroundColor(.gray)
            }.padding(5)
        }
        .navigationTitle(NSLocalizedString("Achievement", comment: "Achievement detail screen title"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .font(.system(size: 20))
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AchievementDetailView(model: AchievementModel(milestone: .thirtyK, date: Date()))
}
