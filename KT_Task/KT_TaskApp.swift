//
//  KT_TaskApp.swift
//  KT_Task
//
//  Created by Ganesh  on 6/28/24.
//

import SwiftUI

@main
struct KT_TaskApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView{
                if Constant.isLogged == "" {
                    LoginView()
                }else{
                    LocationListView()
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
