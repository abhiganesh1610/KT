//
//  CustomNavigationTitleView.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct CustomNavigationTitleView: View {
    @ObservedObject var Uservm = UserManager()
    var userName: String
    @Binding var ShowSwitchUserView : Bool
    var body: some View {
        HStack(alignment: .center){
            Text(userName)
                .fontWeight(.medium)
                .font(.title)
                .foregroundColor(.primary)
            
            Spacer()
            ForEach(0..<Uservm.fetchUser().filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? "1"}).count,id:\.self) { 
                index in
                let item = Uservm.fetchUser().filter({$0.Userid == UserDefaults.standard.string(forKey: "isLogged") ?? "1"})[index]
                Text(item.Name.prefix(1).uppercased())
                    .bold()
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(14)
                    .background(Constant.colors[index % Constant.colors.count])
                    .clipShape(Circle())
                    .onTapGesture {
                        ShowSwitchUserView.toggle()
                    }
            }
          
        }
        .padding(.horizontal)
        .padding(.vertical)
        
    }
}
