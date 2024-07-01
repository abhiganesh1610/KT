//
//  PrimaryButton.swift
//  Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct PrimaryButton: View {
    @State var ButtonName : String
    var body: some View {
        Text(ButtonName)
            .fontWeight(.semibold)
            .font(Font.system(size: 14))
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .foregroundColor(Color.black)
            .background(
                ZStack{
                    RoundedRectangle(cornerRadius: 3)
                        .shadow(color: .black.opacity(0.3), radius: 2,x: 1,y: 2)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(red: 0.97, green: 0.78, blue: 0.27))
                }
            )
            .padding(.vertical)
    }
}

#Preview {
    PrimaryButton(ButtonName: "")
}
