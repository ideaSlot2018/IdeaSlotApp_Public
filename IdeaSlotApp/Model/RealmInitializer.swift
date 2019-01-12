//
//  RealmInitializer.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmInitializer {
    
    static func setUp() {
        // Seed Data
        deleteCategory(CategorySeed())
        deleteWords(WordSeed())
        insertSeedCategories(CategorySeed())
        insertSeedWords(WordSeed())
    }
    
    private static func deleteCategory<T: Seed>(_ seed: T) where T.SeedType: Category {
        // realm
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(T.SeedType.self))
        }
    }
    
    private static func deleteWords<T: BaseWords>(_ seed: T) where T.SeedType: Words {
        // realm
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(T.SeedType.self))
        }
    }
    
    private static func insertSeedCategories<T: Seed>(_ seed: T) where T.SeedType: Category {
        // realm
        let realm = try! Realm()
        try! realm.write {
            T.items().forEach { val in
                realm.add(val, update: true)
            }
        }
    }
    
    private static func insertSeedWords<T: BaseWords>(_ seed: T) where T.SeedType: Words {
        // realm
        let realm = try! Realm()
        try! realm.write {
            T.items().forEach { val in
                realm.add(val, update: true)
                let category = realm.objects(Category.self).filter("categoryId == %@", val.categoryId)
                category.first?.words.append(val)
            }
        }
    }
    
    func removeRealmFile(){
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            try! FileManager.default.removeItem(at: fileURL)
        }
    }
}
