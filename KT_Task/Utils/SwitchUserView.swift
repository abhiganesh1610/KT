//
//  SwitchUserView.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import RealmSwift

struct SwitchUserView: View {
    @ObservedObject var UserManagervm = UserManager()
    @Binding var ShowSwitchUser : Bool
    @State var Userlist : [Users] = []
    var body: some View {
        ZStack{
       
            Color.init(red: 234/255, green: 238/255, blue: 245/255)
                .ignoresSafeArea()
            VStack(spacing: 0){
                
                HStack{
                    Button(action: {
                        ShowSwitchUser.toggle()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.black)
                    })
                    .padding(18)
                    Spacer()
                }
                
                VStack{
                    ScrollView(.vertical,showsIndicators: false){
                        VStack(spacing: 15){
                            ForEach(0..<Userlist.filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? ""}).count,id:\.self) {
                                index in
                                let item = Userlist.filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? ""})[index]
                                Button(action: {
                                    UserDefaults.standard.set("", forKey: "isLogged")
                                    UserDefaults.standard.set(item.Userid, forKey: "isLogged")
                                    ShowSwitchUser.toggle()
                                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "Location"), object: nil, userInfo:nil)
                                }, label: {
                                    HStack(spacing: 15){
                                
                                        Text(item.Name.prefix(1).uppercased())
                                            .bold()
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(Constant.colors[index % Constant.colors.count])
                                            .clipShape(Circle())
                                        
                                        
                                        VStack(alignment: .leading,spacing: 5){
                                            Text(item.Name)
                                                .font(.system(size: 16))
                                                .fontWeight(.regular)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                            
                                            Text(verbatim:item.Email)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                                .accentColor(.gray)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                    }.padding(.leading,12)
                                    
                                })
                            }
                            
                            ForEach(0..<Userlist.filter({$0.Userid != UserDefaults.standard.string(forKey: "isLogged") ?? ""}).count,id:\.self) {
                                index in
                                let item = Userlist.filter({$0.Userid != UserDefaults.standard.string(forKey: "isLogged") ?? ""})[index]
                                Button(action: {
                                    UserDefaults.standard.set("", forKey: "isLogged")
                                    UserDefaults.standard.set(item.Userid, forKey: "isLogged")
                                    ShowSwitchUser.toggle()
                                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "Location"), object: nil, userInfo:nil)
                                }, label: {
                                    HStack(spacing: 15){
                                
                                        Text(item.Name.prefix(1).uppercased())
                                            .bold()
                                            .font(.title3)
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(Constant.colors[index + 2 % Constant.colors.count])
                                            .clipShape(Circle())
                                        
                                        
                                        VStack(alignment: .leading,spacing: 5){
                                            Text(item.Name)
                                                .font(.system(size: 16))
                                                .fontWeight(.regular)
                                                .foregroundColor(.black)
                                                .lineLimit(1)
                                            
                                            Text(verbatim:item.Email)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                                .accentColor(.gray)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                    }.padding(.leading,12)
                                    
                                })
                            }
                            
                            NavigationLink(destination: {
                                SignupView(showSigninbottom:false)
                            }, label: {
                                HStack(spacing: 15){
                                    Image(systemName: "person.badge.plus.fill")
                                        .bold()
                                        .font(.title3)
                                        .padding(.horizontal,10)
                                        .foregroundColor(.black)
                                    
                                    Text("Add another account")
                                        .font(.system(size: 16))
                                        .fontWeight(.regular)
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                    Spacer()
                                }.padding([.leading,.top],10)
                            })
                            
                        }.padding()
                    }
                }
                .frame(maxWidth:.infinity)
                .background(Color.white)
                .cornerRadius(25)
                .padding([.horizontal,.bottom],10)
            }
            .onAppear(perform: {
                Userlist = UserManagervm.fetchUser()
            })
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 20,maxHeight: UIScreen.main.bounds.height * 0.80)
        .cornerRadius(25)
    }
}

#Preview {
    SwitchUserView(ShowSwitchUser: .constant(false))
}
