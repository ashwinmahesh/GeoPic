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
    
    init() { }
    
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
    
    func Log(username: String, firstname: String, lastname: String) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        print("logging")
        do {
            let result = try context.fetch(request).first
            if let user = result {
                user.first_name = username
                user.last_name = lastname
                user.username = username
                user.logged = true
                print("Last User")
                print(user)
            }
            else {
                let user = User(context: context)
                
                user.first_name = username
                user.last_name = lastname
                user.username = username
                user.logged = true
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
