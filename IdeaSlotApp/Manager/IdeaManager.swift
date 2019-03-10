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
        let wordItem: [String:Any]
        var insertWord: Words? = nil
        var categoryLinkedWord: Category? = nil
        
        if category != nil {
            wordItem = ["word": idea.ideaName!,
                        "categoryId": category!.categoryId,
                        "categoryName": category!.categoryName,
                        "ideaFlg": 1
            ]
            insertWord = Words(value: wordItem)
            categoryLinkedWord = category
            
            item = ["ideaName": idea.ideaName!,
                    "categoryName": category!.categoryName,
                    "operatorId1": idea.operator1!,
                    "details": idea.details!,
                    "words": idea.words,
                    "createdWord": insertWord!
            ]
        } else {
            wordItem = ["word": idea.ideaName!,
                        "categoryId": 0,
                        "categoryName": idea.categoryName!,
                        "ideaFlg": 1
            ]
            insertWord = Words(value: wordItem)
            
            item = ["ideaName": idea.ideaName!,
                    "categoryName": idea.categoryName!,
                    "operatorId1": idea.operator1!,
                    "details": idea.details!,
                    "words": idea.words,
                    "createdWord": insertWord!
            ]
        }
        
        //inset word
        if !wordManager.insert(wordName: insertWord!.word!, category: categoryLinkedWord) {
            return false
        }
        
        let insetIdea = Idea(value: item)
        do {
            try realm.write {
                realm.add(insetIdea)
                if category != nil {
                    category?.ideas.append(insetIdea)
                }
            }
        } catch {
            print("Realm Error, insert idea")
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
        } catch {
            print("Realm Error, delete idea")
            return false
        }
        return true
    }
    
}
