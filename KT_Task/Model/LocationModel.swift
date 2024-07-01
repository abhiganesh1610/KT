//
//  LocationModel.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import RealmSwift

class Location: Object, Identifiable {
    @objc dynamic var Userid = UserDefaults.standard.string(forKey: "isLogged") ?? "1"
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var Locationname : String = ""
    @objc dynamic var timestamp: Date = Date()
    
    convenience init(latitude: Double, longitude: Double,Locationname:String, timestamp: Date) {
          self.init()
          self.latitude = latitude
          self.longitude = longitude
          self.Locationname = Locationname
          self.timestamp = timestamp
      }
}
