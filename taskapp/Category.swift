//
//  Category.swift
//  taskapp
//
//  Created by swans on 2019/10/13.
//  Copyright © 2019 swans. All rights reserved.
//

import RealmSwift

class Category: Object {
    //管理用　ID。 プライマリーキー
    @objc dynamic var id = 0
    //category
    @objc dynamic var category = ""
    /** idをプライマリーキーとして設定 **/
    override static func primaryKey() -> String? {
        return "id"
    }
}

