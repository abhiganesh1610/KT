//
//  LoginView.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    
    @ObservedObject var UserManagervm = UserManager()
    @ObservedObject var LocationManagerVm = LocationManager()
    
    @State var EmailAddress : String = ""
    @State var Password : String = ""
    
    @State var isvalidemailid : Bool = false
    @State var isvalidpassword : Bool = false
    
    @State var isActive = false
    @State var emailerrormsg = "enter valid email address"
    @State var passworderrormsg = "enter valid password"
    var body: some View {
        ZStack{
            VStack(alignment:.center,spacing: 10){
                
                HeaderTextView(Title: "Log into your Account", SubTitle: "Welcome back, please enter your details.")
                    .padding(.bottom,10)
                
                TextFieldsViews()
                
                
                Button(action: {
                    
                    isvalidemailid = checkEmailValidation(value: EmailAddress)
                    isvalidpassword = CheckFiledValidataion(Value: Password)
                    
                    if !isvalidemailid && !isvalidpassword {
                        
                        
                        if !UserManagervm.fetchUser().map({$0.Email}).contains(EmailAddress) {
                            isvalidemailid = true
                            emailerrormsg = "User not found!!!"
                            return
                        }
                        
                        for i in UserManagervm.fetchUser().filter({$0.Email == EmailAddress}) {
                            
                            if i.Password == Password {
                                UserDefaults.standard.set("", forKey: "isLogged")
                                UserDefaults.standard.set(i.Userid, forKey: "isLogged")
                                UserDefaults.standard.setValue(true, forKey: "Location")
                                LocationManagerVm.fetchCurrentLocation()
                                isActive = true
                            }else{
                                passworderrormsg = "Password wrong!!!"
                                isvalidpassword = true
                            }
                        }
                    }
                    
                }, label: {
                    PrimaryButton(ButtonName: "Log in")
                })
                .background(NavigationLink("", destination: LocationListView(), isActive: $isActive))
                
                SignUp()
            }
            .frame(width: Constant.LoginScreenWidth)
            .navigationBarHidden(true)
            .onAppear(perform: {
                EmailAddress = ""
                Password = ""
            })
        }
    }
    
    @ViewBuilder
    func TextFieldsViews() -> some View {
        VStack(alignment: .leading,spacing:4){
            
            Text("Email Address *")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            
            
            VStack(alignment: .leading,spacing:5){
                EmailTextField(text: $EmailAddress, titleKey: "enter your email address", WrongPasswordorID: $isvalidemailid)
                
                if isvalidemailid {
                    FieldErrorView(valiedBoolVariabe: $isvalidemailid, Errormessage: emailerrormsg)
                }
            }
            .padding(.bottom)
            
            Text("Password *")
                .font(Font.system(size: 12))
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.31))
            
            VStack(alignment: .leading,spacing:5){
                PasswordTextField(text: $Password, titleKey: "enter your password", WrongPasswordorID: $isvalidpassword)
                
                if isvalidpassword {
                    FieldErrorView(valiedBoolVariabe: $isvalidpassword, Errormessage: passworderrormsg)
                }
            }
            .padding(.bottom)
        }
    }
    
    
    func SignUp() -> some View{
        
        HStack{
            Text("Don't have an account?")
                .font(Font.system(size: 13))
                .foregroundColor(Color.black.opacity(0.7))
            
            NavigationLink(destination: {
                SignupView(showSigninbottom:true)
            }, label: {
                Text("Sign up")
                    .fontWeight(.bold)
                    .font(Font.system(size: 13))
                    .foregroundColor(Color.black)
                    .underline()
            })
        }.padding(.vertical)
    }
    
}

#Preview {
    LoginView()
}
