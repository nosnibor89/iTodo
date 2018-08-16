//
//  Todo.swift
//  iTodo
//
//  Created by Robinson Marquez on 8/7/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import RealmSwift

class Todo: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createdAt: Date = Date()
    
    
    // property refers to the relationship property name
    var category = LinkingObjects(fromType: Category.self, property: "todos")
}
