//
//  HeaderTextView.swift
//  Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct HeaderTextView: View {
    @State var Title : String
    @State var SubTitle : String
    var body: some View {
        VStack(spacing: 5){
            Text(Title)
                .font(Font.system(size: 22).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Text(SubTitle)
                .font(Font.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
    }
}

//#Preview {
//    HeaderTextView()
//}


