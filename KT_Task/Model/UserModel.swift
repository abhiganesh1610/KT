//
//  UserModel.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import RealmSwift

class Users: Object, Identifiable {
    @objc dynamic var Userid = UUID().uuidString
    @objc dynamic var Name: String = ""
    @objc dynamic var Email: String = ""
    @objc dynamic var Password : String = ""
    
    convenience init(Userid:String,Name:String,Email:String,Password:String) {
          self.init()
          self.Userid = Userid
          self.Name = Name
          self.Email = Email
          self.Password = Password
      }
}
