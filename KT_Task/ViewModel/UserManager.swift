//
//  UserManager.swift
//  KT_Task
//
//  Created by Ganesh  on 6/29/24.
//

import SwiftUI
import RealmSwift


class UserManager : NSObject, ObservableObject {
    
    @Published var UserList : [Users] = []
    
    // Save location
    func SaveUserdeatail(Users: Users) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(Users)
        }
    }
    
    func fetchUser() -> [Users] {
        let realm = try! Realm()
        let results = realm.objects(Users.self)
        return Array(results)
    }
}
