//
//  PasswordTextField.swift
//  Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct PasswordTextField: View {
    @Binding var text: String
    @State var isSecure: Bool = true
    var titleKey: String
    @Binding var WrongPasswordorID : Bool
    var body: some View {
        HStack{
            Group{
                if isSecure{
                    SecureField(titleKey, text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                }else{
                    TextField(titleKey, text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                }
                
                Button(action: {
                    withAnimation(.smooth){
                        isSecure.toggle()
                    }
                }, label: {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                })
            }.animation(.easeInOut(duration: 0.05), value: isSecure)
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
