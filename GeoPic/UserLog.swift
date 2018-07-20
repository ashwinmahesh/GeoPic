//
//  UserLog.swift
//  GeoPic
//
//  Created by El Capitan on 7/18/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserLog {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var first_name: String = ""
    var last_name: String = ""
    var userName: String = ""
    var logged: Bool = false
    var upload_count: Int16 = 0
    
    init() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        //        let filter = "first_name==%@ && last_name==%@ && username==%@"
        //        request.predicate = NSPredicate(format: filter, firstname, lastname, username)
        do {
            let result = try context.fetch(request).first
            if result != nil {
                self.first_name = (result?.first_name)!
                self.last_name = (result?.last_name)!
                self.userName = (result?.username)!
                self.logged = (result?.logged)!
                self.upload_count = (result?.upload_count)!
            }
        } catch {
            print("\(error)")
        }
    }
    
    func isLogged() -> Bool {
        print("Checking Logs")
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let result = try context.fetch(request).first
            if let user = result {
                print(user)
                return user.logged
            }
        } catch {
            print("\(error)")
        }
        return false
    }
    
    func inLogs(username: String, firstname: String, lastname: String) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let filter = "first_name==%@ && last_name==%@ && username==%@"
        request.predicate = NSPredicate(format: filter, firstname, lastname, username)
        do {
            let result = try context.fetch(request).first
            if result != nil {
                return true
            }
        } catch {
            print("\(error)")
        }
        return false
    }
    
    func Log(username: String, firstname: String, lastname: String, upload_count:Int16) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        print("logging")
        do {
            let result = try context.fetch(request).first
            if let user = result {
                user.first_name = firstname
                user.last_name = lastname
                user.username = username
                user.logged = true
                user.upload_count = upload_count
                print("Last User")
                print(user)
            }
            else {
                let user = User(context: context)
                
                user.first_name = firstname
                user.last_name = lastname
                user.username = username
                user.logged = true
                user.upload_count = upload_count
                print(user)
                print("Logged")
            }
        } catch {
            print("\(error)")
        }
        
        appDelegate.saveContext()
    }
    
    func LogOut() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        //        request.predicate = NSPredicate(format: "username==%@", username)
        
        do {
            let result = try context.fetch(request).first
            if let user = result {
                user.logged = false
            }
        } catch {
            print("\(error)")
        }
        appDelegate.saveContext()
    }
    
}
