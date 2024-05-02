//
//  ChartView.swift
//  MySteps
//
//  Created by alex on 02/05/2024.
//

import SwiftUI

struct ChartView: View {
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Steps")
                    .font(.system(size: 32, weight: .black, design: .default))
                    .foregroundColor(.white)
                Text("March 2023")
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("34.345")
                    .font(.system(size: 32, weight: .regular, design: .default))
                    .foregroundColor(Color("steps-green"))
                Spacer()
            }
        }
    }
}

#Preview {
    ChartView()
}
