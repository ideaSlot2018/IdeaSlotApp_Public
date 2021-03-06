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
     register category
     @param newCategoryName : String
     */
    func register(newCategoryName: String) -> Bool {
        //check new category name exists
        if !checkIncludeCategoryName(categoryName: newCategoryName) {
            return false
        }
        
        let item: [String: Any] = ["categoryId":getCategoryMaxId(),
                                   "categoryName":newCategoryName,
                                   ]
        
        let editCategory = Category(value: item)
        do {
            try realm.write {
                realm.add(editCategory)
            }
        } catch  {
            print("Realm Error, register category")
            return false
        }
        return true
    }
    
    /*
     update category
     @param category : Category(not nil)
     @param newCategoryName : String
     */
    func update(category: Category, newCategoryName: String) -> Bool {
        //check new category name exists
        if !checkIncludeCategoryName(categoryName: newCategoryName) {
            return false
        }

        do {
            try realm.write {
                category.categoryName = newCategoryName
                category.updateDate = Date()
            }
        } catch  {
            print("Realm Error, register category")
            return false
        }
        return true
    }
    
    //delete category
    /*
     delete category
     @param category : Category
     @return : Bool
     */
    func delete(category: Category) -> Bool{
        
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
        }
        return nil
    }
    
    /*
     return one item Category filter by categoryId
     @param categiryId : Int
     @return
     true -> Category()
     false -> nil
     */
    func findCategoryItem(categoryId: Int) -> Category? {
        let category = getResultsCategory(filterName: "categoryId", filterItem: categoryId, sort: nil, ascending: nil)?.first
        if category != nil {
            return category
        }
        return nil
    }
    
    /*
     return max category id + 1
     @return Int
     */
    func getCategoryMaxId() -> Int {
        var categoryMaxId:Int = 1
        let category = getResultsCategory(filterName: nil, filterItem: nil, sort: nil, ascending: nil)
        if category != nil && category!.count > 0 {
            categoryMaxId = category!.max(ofProperty: "categoryId")! + 1
        }
        return categoryMaxId
    }
    
    /*
     check new category name already exists
     @param categoryName : String
     @return Bool
     */
    func checkIncludeCategoryName(categoryName: String) -> Bool {
        let categoryList = getResultsCategory(filterName: "categoryName", filterItem: categoryName, sort: nil, ascending: nil)?.value(forKey: "categoryName") as! Array<Any>
        
        if categoryList.count > 0  {
            return false
        }
        return true
    }
}
