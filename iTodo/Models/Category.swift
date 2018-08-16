//
//  Category.swift
//  iTodo
//
//  Created by Robinson Marquez on 8/7/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let todos = List<Todo>()
}
