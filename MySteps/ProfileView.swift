//
//  ProfileView.swift
//  MySteps
//
//  Created by alex on 01/05/2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Image("profile-background")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
            
            
            Circle()
                .fill(Color.white.opacity(0.2)) // Set the fill color and make it semi-transparent
                   .frame(width: 185, height: 185) //
            
            
                    
            Image("profile-photo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .clipShape(Circle())
//                .overlay(
//                    Circle().stroke(Color.gray.opacity(0.1), lineWidth: 4) // Semi-transparent white border
//                          )
        }
    }
}

#Preview {
    ProfileView()
}
