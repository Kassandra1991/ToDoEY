//
//  Category.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-30.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
