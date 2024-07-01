//
//  FieldErrorView.swift
//  Bharathi Institute
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct FieldErrorView : View {
    @Binding var valiedBoolVariabe : Bool
    @State var Errormessage : String
    var body: some View {
        SwiftUI.Text(Errormessage)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(Color.red)
            .padding(.leading,8)
            .transition(.opacity)
            .offset(y: valiedBoolVariabe ? 0 : -30)
    }
}


func CheckFiledValidataion(Value:String) -> Bool{
    var boolvalue = false
    if Value.count > 0 {
        for i in Value {
            if i.isLetter || i.isNumber {
                boolvalue = false
            }else{
                if Value.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty {
                    boolvalue =  true
                }
            }
        }
    }else{
        boolvalue =  true
    }
    return boolvalue
}



func checkEmailValidation(value: String) -> Bool {
    let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    
    if emailPredicate.evaluate(with: trimmedValue) {
        return !trimmedValue.contains("@gmail.com")
    }
    
    return true
}

