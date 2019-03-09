//
//  CategoryManager.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/03/09.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryManager {
    
    let realm = try! Realm()
    let wordManager = WordManager()
    
    
    /*
     get realm categiries results
     @param filterName : String
     @param filterItem : Any
     @param sort : String
     @param ascending : Bool
     @return Results<Category>
     */
    func getResultsCategory(filterName:String?, filterItem:Any?, sort:String?, ascending:Bool?) -> Results<Category>? {
        
        guard var categoriesArray:Results<Category> = realm.objects(Category.self) else {
            print("Realm Error, select categories")
            return nil
        }
        //add filter
        if filterName != nil && filterItem != nil {
            if !filterName!.isEmpty {
                categoriesArray = categoriesArray.filter(filterName! + " == %@", filterItem!)
            }
        }
        //add sort
        if sort != nil {
            if !sort!.isEmpty {
                categoriesArray = categoriesArray.sorted(byKeyPath: sort!, ascending: ascending!)
            }
        }
        return categoriesArray
    }
    
    /*
     register or update category
     @param category : Category
     @param formtext : String
     */
    func register(category: Category?, newCategoryName: String) -> Bool {
        let item: [String: Any]
        
        if category != nil { //update
            let newWords = wordManager.convertWordList(category: category!, categoryName: newCategoryName)
            item = ["categoryId":category!.categoryId,
                    "categoryName":newCategoryName,
                    "words":newWords,
                    "createDate":category!.createDate
            ]
        }else{ //insert
            item = ["categoryId":getCategoryMaxId(),
                    "categoryName":newCategoryName,
            ]
        }
        
        let editCategory = Category(value: item)
        do {
            try realm.write {
                realm.add(editCategory, update: true)
            }
        } catch  {
            print("Realm Error, register category")
            return false
        }
        
        return true
    }
    
    //delete category
    func delete(category: Category) -> Bool{
        let words:Results<Words>? = wordManager.getResultsWords(filterName: "categoryId", filterItem: category.categoryId, sort: nil, ascending: nil)
        let oldCategory:Category = category
        
        //convert words
        for word in words!{
            let result = wordManager.update(wordName: word.word!, category: nil, wordItem: word, oldCategory: oldCategory)
            print("convert word:", word.word!, result)
        }
        
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Realm Error, delete category")
            return false
        }
        return true
    }
    
    /*
     return category name list
     @param listFlg : Int(0,1)
     @return Array<String>
     */
    func arrayCategoryList(listFlg: Int) -> Array<String> {
        var CategoryNameList: [String] = []
        let CategoryList = getResultsCategory(filterName: nil, filterItem: nil, sort: "categoryId", ascending: true)
        
        //IdeaSlotViewController append "All" or "No Category"
        switch listFlg {
        case 0:
            CategoryNameList.append("No Category")
        case 1:
            CategoryNameList.append("All")
        default:
            break
        }
        
        //create ArrayList only categoryName
        for Category in CategoryList!{
            CategoryNameList.append(Category.categoryName)
        }
        return CategoryNameList
    }
    
    //return one item Category filter by categoryName
    /*
     return one item Category filter by categoryName
     @param categiryName : String
     @return
     true -> Category()
     false -> nil
     */
    func findCategoryItem(categoryName: String) -> Category? {
        let category = getResultsCategory(filterName: "categoryName", filterItem: categoryName, sort: nil, ascending: nil)?.first
        if category != nil {
            return category
        } else {
            return nil
        }
    }
    
    /*
     return max category id + 1
     @return Int
     */
    func getCategoryMaxId() -> Int {
        var categoryMaxId:Int = 1
        let category:Category? = getResultsCategory(filterName: nil, filterItem: nil, sort: "categoryName", ascending: false)?.first
        if category != nil {
            categoryMaxId =  category!.categoryId + 1
        }
        return categoryMaxId
    }
    
}
