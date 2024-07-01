//
//  EmailTextField.swift
//  Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var text: String
    var titleKey: String
    @Binding var WrongPasswordorID : Bool
    var body: some View {
        HStack{
            TextField(titleKey, text: $text)
                .font(.system(size: 14))
                .foregroundColor(Color.black)
                .keyboardType(.emailAddress)
                .submitLabel(.done)
                .autocorrectionDisabled()
                .autocapitalization(.none) // Disable autocapitalization
                .onChange(of: text) { newValue in
                    text = newValue.lowercased()
                }
            
        }
        .padding(.horizontal,10)
        .frame(height: 45)
        .background(
            ZStack{
                RoundedRectangle(cornerRadius:3)
                    .stroke(WrongPasswordorID ? Color.red : Color.black ,lineWidth:1)
                RoundedRectangle(cornerRadius:3)
                    .foregroundColor(Color.white)
            }
        )
    }
}
