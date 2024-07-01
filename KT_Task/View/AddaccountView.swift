//
//  AddaccountView.swift
//  KT_Task
//
//  Created by Ganesh  on 6/29/24.
//

import SwiftUI

struct AddaccountView: View {
    @ObservedObject var UserManagervm = UserManager()
    
    @Environment(\.presentationMode) private var presentationMode
    @State var isvalidemail = false
    @State var isvalidname = false
    @State var isvalidpassword = false
    @State var isvalidconfirmpassword = false
    
    // API Params
    @State var Name : String = ""
    @State var EmailAddress : String = ""
    @State var Password : String = ""
    @State var ConfirmPassword : String = ""
    
    @State var emailerrormsg = "enter valid email address"
    var body: some View {
        ZStack{
            VStack{
                VStack(spacing: 15){
                    
                    HeaderTextView(Title: "Create an Account", SubTitle: "Sign up now to get started with an account.")
                    
                    Textfieldsview()
                    
                    Button(action: {
                        
                        isvalidemail = checkEmailValidation(value: EmailAddress)
                        isvalidname = CheckFiledValidataion(Value: Name)
                        isvalidpassword = CheckFiledValidataion(Value: Password)
                        isvalidconfirmpassword = CheckFiledValidataion(Value: ConfirmPassword)
                        
                        if !isvalidemail && !isvalidname && !isvalidpassword && !isvalidconfirmpassword {
//
                            if Password != ConfirmPassword {
                                isvalidpassword = true
                                isvalidconfirmpassword = true
                                return
                            }
                            
                            let User = Users(Userid: String(describing: UserManagervm.fetchUser().count + 1), Name: Name, Email: EmailAddress, Password: Password)
                            
                            print(User)
                            
                            if !UserManagervm.fetchUser().map({$0.Email}).contains(EmailAddress) {
                                
                                UserManagervm.SaveUserdeatail(Users: User)
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }else{
                                isvalidemail = true
                                emailerrormsg = "Email already exsit"
                            }
                        }
                        
                    }, label: {
                        PrimaryButton(ButtonName: "Sign up")
                    })
                    
                    BacktoLogin()
                    
                }
                .frame(width: Constant.LoginScreenWidth)
                
            }.navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    func Textfieldsview() -> some View {
        
        VStack(alignment: .leading,spacing: 5){
            Text("Name *")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            
            VStack(alignment: .leading,spacing:5){
                TextFields(text: $Name, titleKey: "enter your name", WrongPasswordorID: $isvalidname)
                
                if isvalidname {
                    FieldErrorView(valiedBoolVariabe: $isvalidname, Errormessage: "enter valid name")
                }
            }
            .padding(.bottom)
            
            Text("Email Address *")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            
            VStack(alignment: .leading,spacing:5){
                EmailTextField(text: $EmailAddress, titleKey: "enter your email address", WrongPasswordorID: $isvalidemail)
                
                if isvalidemail {
                    FieldErrorView(valiedBoolVariabe: $isvalidemail, Errormessage: emailerrormsg)
                }
            }
            .padding(.bottom)
    
            
            Text("Password *")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            
            VStack(alignment: .leading,spacing:5){
                PasswordTextField(text: $Password, titleKey: "enter your password", WrongPasswordorID: $isvalidpassword)
                
                if isvalidpassword {
                    FieldErrorView(valiedBoolVariabe: $isvalidpassword, Errormessage: "enter valid password")
                }
            }
            .padding(.bottom)
            
            
            Text("Confirm Password *")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            
            VStack(alignment: .leading,spacing:5){
                PasswordTextField(text: $ConfirmPassword, titleKey: "enter your confirm password", WrongPasswordorID: $isvalidconfirmpassword)
                
                if isvalidconfirmpassword {
                    FieldErrorView(valiedBoolVariabe: $isvalidconfirmpassword, Errormessage: "enter valid confirm password")
                }
            }
            .padding(.bottom)
            
        }
    }
    
    func BacktoLogin() -> some View {
        HStack(spacing: 3){
            Spacer()
            Text("Already have an account?  ")
                .font(
                    Font.system(size: 13)
                )
                .foregroundColor(Color.black.opacity(0.7))
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Sign In")
                    .fontWeight(.bold)
                    .font(Font.system(size: 13))
                    .foregroundColor(Color.black)
                    .underline()
            })
            Spacer()
        }.padding(.vertical,12)
    }
}

#Preview {
    AddaccountView()
}
