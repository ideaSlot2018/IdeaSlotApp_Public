//
//  RealmModel.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/04.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class Base: Object{
    @objc dynamic var createDate = Date()
    @objc dynamic var updateDate = Date()
}

class User: Base{
    @objc dynamic var userId: String? = "UID" + NSUUID().uuidString
    @objc dynamic var userName: String? = ""
    @objc dynamic var password: String? = ""
    
    override class func primaryKey() -> String {
        return "userId"
    }
    //    override static func indexedProperties() -> [String] {
    //        return ["userId"]
    //    }
}

class Words: Base {
    @objc dynamic var wordId: String? = "WID" + NSUUID().uuidString
    @objc dynamic var word: String? = ""
    let category = LinkingObjects(fromType: Category.self, property: "words")
    let idea = LinkingObjects(fromType: Idea.self, property: "createdWord")
    @objc dynamic var userId: String? = ""
    @objc dynamic var ideaFlag: Int = 0
    
    override class func primaryKey() -> String {
        return "wordId"
    }
    //    override static func indexedProperties() -> [String] {
    //        return ["wordId"]
    //    }
}

class Category: Base {
    @objc dynamic var categoryId:Int = 0
    @objc dynamic var categoryName = ""
    //    @objc dynamic var userId: String? = ""
    let words = List<Words>()
    let ideas = List<Idea>()
    
    override class func primaryKey() -> String {
        return "categoryId"
    }
    
}

class Idea: Base {
    @objc dynamic var ideaId: String? = "IID" + NSUUID().uuidString
    @objc dynamic var ideaName: String? = ""
    @objc dynamic var categoryName: String? = ""
    //@objc dynamic var userId: String? = ""
    @objc dynamic var operatorId1: String? = "Plus"
    //@objc dynamic var operatorId2: String? = ""
    @objc dynamic var details: String? = ""
    let words = List<Words>(repeating: Words(), count: 2)
    let category = LinkingObjects(fromType: Category.self, property: "ideas")
    @objc dynamic var createdWord: Words? = nil
    
    override class func primaryKey() -> String {
        return "ideaId"
    }
    //    override static func indexedProperties() -> [String] {
    //        return ["ideaId"]
    //    }
}
