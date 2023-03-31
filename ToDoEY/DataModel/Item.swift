//
//  Item.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-30.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")
}
