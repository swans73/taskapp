//
//  Task.swift
//  taskapp
//
//  Created by swans on 2019/09/26.
//  Copyright © 2019 swans. All rights reserved.
//

import RealmSwift

class Task: Object {
    //管理用　ID。 プライマリーキー
    @objc dynamic var id = 0
    //タイトル
    @objc dynamic var title = ""
    //内容
    @objc dynamic var date = Date()
    /** idをプライマリーキーとして設定 **/
    override static func primaryKey() -> String? {
        return "id"
    }
}
