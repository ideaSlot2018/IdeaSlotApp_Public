//
//  IdeaManager.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/03/09.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import Foundation
import RealmSwift

class IdeaManager {
    
    let realm = try! Realm()
    let wordManager = WordManager()
    let categoryManager = CategoryManager()
    
    /*
     get realm words results
     @param filterName : String
     @param filterItem : Any
     @param sort : String
     @param ascending : Bool
     @return Results<Words>
     */
    func getResultsIdeas(filterName:String?, filterItem:Any?, sort:String?, ascending:Bool?) -> Results<Idea>? {
        guard var ideasArray:Results<Idea> = realm.objects(Idea.self) else {
            print("Realm Error, select ideas")
            return nil
        }
        //add filter
        if filterName != nil && filterItem != nil {
            if !filterName!.isEmpty {
                ideasArray = ideasArray.filter(filterName! + " == %@", filterItem!)
            }
        }
        //add sort
        if sort != nil {
            if !sort!.isEmpty {
                ideasArray = ideasArray.sorted(byKeyPath: sort!, ascending: ascending!)
            }
        }
        return ideasArray
    }

    //register idea
    /*
     register idea
     @param new
     */
    func register(idea:IdeaDto) -> Bool {
        let category:Category? = categoryManager.findCategoryItem(categoryName: idea.categoryName!)
        let item: [String:Any]
        
        //check idea name
        if !checkIncludeIdeaName(ideaname: idea.ideaName!, category: category) {
            return false
        }
        
        //set word data
        let wordItem: [String:Any] = ["word": idea.ideaName!,
                    "ideaFlg": 1
        ]
        let insertWord = Words(value: wordItem)

        //set idea data
        if category != nil {
            
            item = ["ideaName": idea.ideaName!,
                    "categoryId": category!.categoryId,
                    "operatorId1": idea.operator1!,
                    "details": idea.details!,
                    "words": idea.words
            ]
        } else {
            item = ["ideaName": idea.ideaName!,
                    "operatorId1": idea.operator1!,
                    "details": idea.details!,
                    "words": idea.words
            ]
        }
        
        //insert
        let insertIdea = Idea(value: item)
        do {
            try realm.write {
                realm.add(insertIdea)
                insertIdea.createdWord = insertWord
                if category != nil {
                    category?.ideas.append(insertIdea)
                    category?.words.append(insertWord)
                }
            }
        } catch {
            print("Realm Error, insert idea")
            return false
        }
        return true
    }
    
    /*
     update idea
     @param idea : Idea
     @param ideaName : String
     @param details : String
     @param category : Category
     @return Bool
     */
    func update(idea: Idea, ideaName:String, details:String, category: Category?) -> Bool {
        var removeIdeaIndex:Int? = nil
        let oldCategory = idea.category.first
        
        print(idea)
        
        //check duplicated
        if ideaName != idea.ideaName {
            if !checkIncludeIdeaName(ideaname: ideaName, category: category){
                return false
            }
        }
        //get index of old category
        if oldCategory != nil {
            removeIdeaIndex = oldCategory?.ideas.index(matching: "ideaId == %@", idea.ideaId!)
        }
        
        do {
            try realm.write {
                if category != nil{
                    idea.ideaName = ideaName
                    idea.categoryId = category!.categoryId
                    idea.details = details
                    idea.updateDate = Date()
                    category?.ideas.append(idea)
                } else {
                    idea.ideaName = ideaName
                    idea.categoryId = 0
                    idea.details = details
                    idea.updateDate = Date()
                }
                if removeIdeaIndex != nil {
                    oldCategory?.ideas.remove(at: removeIdeaIndex!)
                    realm.create(Category.self, value: oldCategory!, update: true)
                }
            }
            
            let result = wordManager.update(wordName: ideaName, category: category, wordItem: idea.createdWord!, oldCategory: oldCategory)
            if !result {
                throw NSError(domain: "errorメッセージ", code: -1, userInfo: nil)
            }
        } catch {
            print("Realm Error, update idea")
            return false
        }
        
        return true
    }
    
    /*
     delete idea
     @param idea : Idea
     @return : Bool
     */
    func delete(idea: Idea) -> Bool{
        
        do {
            try realm.write {
                realm.delete(idea)
            }
            
            let result = wordManager.delete(word: idea.createdWord!)
            if !result {
                print("failure ")
            }
            
        } catch {
            print("Realm Error, delete idea")
            return false
        }
        return true
    }
    
    /*
     check new idea name already exists
     @param ideaname : String
     @param category : Category
     @return : Bool
     */
    func checkIncludeIdeaName(ideaname: String, category: Category?) -> Bool {
        var param:Int = 0
        if category != nil {
            param = category!.categoryId
        }
        
        
        let ideaList = getResultsIdeas(filterName: "ideaName", filterItem: ideaname, sort: nil, ascending: nil)!
            .filter("categoryId == %@", param)
            .value(forKey: "ideaName") as! Array<Any>
        
        if ideaList.count > 0 {
            return false
        }
        return true
    }
    
}
