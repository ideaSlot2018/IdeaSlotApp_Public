//
//  WordManager.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/03/09.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class WordManager {
    
    let realm = try! Realm()
    
    /*
     get realm words results
     @param filterName : String
     @param filterItem : Any
     @param sort : String
     @param ascending : Bool
     @return Results<Words>
     */
    func getResultsWords(filterName:String?, filterItem:Any?, sort:String?, ascending:Bool?) -> Results<Words>? {
        guard var wordsArray:Results<Words> = realm.objects(Words.self) else {
            print("Realm Error, select words")
            return nil
        }
        //add filter
        if filterName != nil && filterItem != nil {
            if !filterName!.isEmpty {
                wordsArray = wordsArray.filter(filterName! + " == %@", filterItem!)
            }
        }
        //add sort
        if sort != nil {
            if !sort!.isEmpty {
                wordsArray = wordsArray.sorted(byKeyPath: sort!, ascending: ascending!)
            }
        }
        return wordsArray
    }
    
    /* insert new word
     @param text : String
     @param categoryName : String
     @return Bool
     */
    func insert(wordName: String, category: Category?) -> Bool{
        var item: [String: Any]? = nil
        
        //selected category
        if category != nil {
            item = ["word": wordName,
                    "categoryId": category!.categoryId,
                    "categoryName": category!.categoryName]
        }else{
            item = ["word": wordName,
                    "categoryId": 0,
                    "categoryName": "No Category"]
        }
        
        let newWord = Words(value: item!)
        do {
            try realm.write(){
                realm.add(newWord)
                if category?.categoryId != 0{
                    category?.words.append(newWord)
                }
            }
        } catch {
            print("Realm Error, insert word")
            return false
        }
        return true
    }
    
    /*
     update word data
     @param wordName : String
     @param category : Category
     @param wordItem : Words
     @param oldCategory : Category
     @return Bool
     */
    func update(wordName: String, category: Category?, wordItem: Words, oldCategory: Category?) -> Bool{
        let item: [String: Any]
        
        //selected category
        if category != nil {
            item = ["wordId": wordItem.wordId!,
                    "word": wordName,
                    "categoryId": category!.categoryId,
                    "categoryName": category!.categoryName,
                    "createDate":wordItem.createDate
            ]
        }else{
            item = ["wordId": wordItem.wordId!,
                    "word": wordName,
                    "categoryName": "No Category",
                    "createDate":wordItem.createDate
            ]
        }
        
        var removeWordItemIndex:Int? = nil
        if oldCategory != nil {
            removeWordItemIndex = oldCategory!.words.index(matching: "wordId == %@", wordItem.wordId!)
        }
        
        let editWord = Words(value: item)
        do {
            try realm.write(){
                realm.add(editWord, update: true)
                if category != nil{
                    category!.words.append(editWord)
                }
                if removeWordItemIndex != nil{
                    oldCategory!.words.remove(at: removeWordItemIndex!)
                    realm.create(Category.self, value: oldCategory!, update: true)
                }
            }
        } catch  {
            print("Realm Error, update word")
            return false
        }
        return true
    }
    
    /*
     delete word
     @param word : Words
     @return Bool
     */
    func delete(word: Words) -> Bool {
        do {
            try realm.write {
                realm.delete(word)
            }
        } catch  {
            print("Realm Error, delete word")
            return false
        }
        return true
    }
    
    //update word's category name when category cahnged
    func convertWordList(category:Category, categoryName:String) -> Array<Words> {
        var newWords:Array<Words>? = Array()
        let oldCategory:Category? = category
        do {
            try realm.write {
                category.categoryName = categoryName
            }
        } catch  {
            print("Realm Error, set category name for cnvert")
            return Array()
        }
        
        let words:Results<Words>? = getResultsWords(filterName: "categoryId", filterItem: category.categoryId, sort: nil, ascending: nil)
        
        for word in words! {
            let result = update(wordName: word.word!, category: category, wordItem: word, oldCategory: oldCategory)
            if result {
                newWords?.append(word)
            }
        }
        
        return newWords!
    }
    
}