//
//  UIViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/09/08.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

extension UIViewController{
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "Menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
//        setNavigationBarTitle()
    }
    
    func setNavigationBarRightItem(imageName: String) {
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView:button)
        let currWidth = rightButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = rightButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true

        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func rightButtonAction() {}
    
    func setNavigationBarTitle(){
        let navigationTitle = UIImageView(image: UIImage(named: "Header"))
        navigationTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        self.navigationItem.titleView = navigationTitle
    }
    
    func customBackButton(){
        self.slideMenuController()?.removeLeftGestures()

        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.addTarget(self, action: #selector(toBack), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView:button)
        let currWidth = backButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        let currHeight = backButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = backButton
//        setNavigationBarTitle()
    }
    
    @objc func toBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //return category name list
    func arrayCategoryList(listFlg: Int) -> Array<String> {
        let realm = try!Realm()
        var CategoryNameList: [String] = []
        let CategoryList = realm.objects(Category.self)
        
        //IdeaSlotViewController append "All"
        switch listFlg {
        case 0:
            CategoryNameList.append("No Category")
        case 1:
            CategoryNameList.append("All")
        default:
            break
        }
        
        //create ArrayList only categoryName
        for Category in CategoryList{
            CategoryNameList.append(Category.categoryName)
        }
        return CategoryNameList
    }
    
    //return one item Category filter by categoryName
    func findCategoryItem(categoryName: String) -> Category {
        let realm = try!Realm()
        let categoryItem = realm.objects(Category.self).filter("categoryName = %@",categoryName)
        if categoryItem.first != nil {
            return categoryItem.first!
        } else {
            return Category()
        }
    }
    
    func getCategoryMaxId() -> Int {
        let realm = try!Realm()
        let categoryMaxId: Int = (realm.objects(Category.self).sorted(byKeyPath: "categoryId", ascending: true).last?.categoryId)! + 1
        return categoryMaxId
    }
}
