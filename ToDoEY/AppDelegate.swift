//
//  AppDelegate.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-20.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            _ = try Realm()
        } catch {
            print("Error init Realm: \(error.localizedDescription)")
        }
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        return true
    }
}
