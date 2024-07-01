//
//  Constant.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

struct Constant {
    
    static let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    static var APIkEY = "AIzaSyCWbEyLf0DEM9bSiLESagxUyVPBQ7At0KY"
    
    static var LoginScreenWidth = UIScreen.main.bounds.width * 0.85
    
    static var isLogged = UserDefaults.standard.string(forKey: "isLogged") ?? ""
    static var CountLocation = UserDefaults.standard.bool(forKey: "Location")
}
