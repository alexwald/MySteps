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
            Image("achievement-30k") // used as the colorful blur behind the profile picture
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .blur(radius: 30)
            
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 190, height: 190)
                    
            Image("profile-photo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ProfileView()
}
