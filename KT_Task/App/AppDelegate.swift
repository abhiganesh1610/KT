//
//  AppDelegate.swift
//  Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Constant.APIkEY)
        return true
    }
}
