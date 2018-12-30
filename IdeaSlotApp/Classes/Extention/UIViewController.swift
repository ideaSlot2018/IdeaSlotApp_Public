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
    
    func setNavigationBarTitle(title: String){
        let navigationTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        navigationTitle.font = UIFont.systemFont(ofSize: 21)
        navigationTitle.text = title
        navigationTitle.textAlignment = .center
        navigationTitle.textColor = UIColor.AppColor.navigationTitle
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
    }
    
    @objc func toBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //return category name list
    func arrayCategoryList() -> Array<String> {
        let realm = try!Realm()
        var CategoryNameList: [String] = []
        let CategoryList = realm.objects(Category.self)
        
        //create ArrayList only categoryName
        for Category in CategoryList{
            CategoryNameList.append(Category.categoryName)
        }
        return CategoryNameList
    }
    
    //return one item Category filter by categoryName
    func findCategoryItem(categoryName: String) -> Results<Category> {
        let realm = try!Realm()
        let categoryItem = realm.objects(Category.self).filter("categoryName = %@",categoryName)
        return categoryItem
    }
    
    func setCateoryDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.dataSource = arrayCategoryList()
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
        }
    }
}
