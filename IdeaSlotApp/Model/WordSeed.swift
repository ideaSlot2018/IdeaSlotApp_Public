//
//  WordSeed.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

protocol BaseWords {
    associatedtype SeedType: Words
    static var values: [[Any]] { get }
    static func items() -> [SeedType]
}

extension BaseWords {
    static func items() -> [SeedType] {
        return values.map { val in
            let t = SeedType()
            t.word = val[0] as? String
            t.categoryId = val[1] as! Int
            t.categoryName = val[2] as? String
            t.createDate = (val[3] as! Date)
            return t
        }
    }
}

struct WordSeed: BaseWords {
    typealias SeedType = Words
    static var values: [[Any]] {
        return WordData.data
    }
}

struct WordData {
    static let data: [[Any]] = [
        ["big", 1, "Condition", Date()],
        ["small", 1, "Condition", Date()],
        ["tall", 1, "Condition", Date()],
        ["slim", 1, "Condition", Date()],
        ["wide", 1, "Condition", Date()],
    ]
}
