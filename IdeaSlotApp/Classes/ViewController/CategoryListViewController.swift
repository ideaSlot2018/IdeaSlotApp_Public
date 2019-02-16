//
//  CategoryListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import PopupWindow

class CategoryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categoryEntities: Results<Category>? = nil
    var category: Category? = nil

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        setNavigationBarItem()
        setNavigationBarRightItem(imageName: "Plus")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.register(UINib(nibName: "CategoryItemCell", bundle: nil),forCellReuseIdentifier:"CategoryItem")
        tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryEntities = realm.objects(Category.self)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toWordList":
            let wordListViewController = segue.destination as! WordsListViewController
            let category = categoryEntities![tableView.indexPathForSelectedRow!.row]
            wordListViewController.category = category
        default:
            break
        }
    }
    
    override func rightButtonAction() {
        setRegistFrom(category: Category())
    }
    
    //display category regist form
    func setRegistFrom(category:Category){
        let categoryRegistFormViewController = CategoryRegistFormViewController()
        categoryRegistFormViewController.categoryTableView = self.tableView
        categoryRegistFormViewController.category = category
        PopupWindowManager.shared.changeKeyWindow(rootViewController: categoryRegistFormViewController)
    }
    
    //display delete alert
    func setDeleteAlert(category:Category){
        let categoryDeleteAlertViewController = CategoryDeleteAlertViewController()
        categoryDeleteAlertViewController.categoryTableView = self.tableView
        categoryDeleteAlertViewController.category = category
        PopupWindowManager.shared.changeKeyWindow(rootViewController: categoryDeleteAlertViewController)
    }
    
    //regist or update category
    func registCategory(category: Category, formText: String) -> Bool {
        let item: [String: Any]
        
        if category.categoryId != 0 {
            let newWords = self.convertWords(category: category, categoryName: formText)
            item = ["categoryId":category.categoryId,
                    "categoryName":formText,
                    "words":newWords,
                    "createDate":category.createDate
            ]
        }else{
            item = ["categoryId":getCategoryMaxId(),
                    "categoryName":formText,
            ]
        }
        
        let editCategory = Category(value: item)
        try! realm.write {
            realm.add(editCategory, update: true)
        }
        
        return true
    }
    
    //update word's category name when category cahnged
    private func convertWords(category:Category, categoryName:String) -> Array<Words>{
        var newWords:Array<Words>? = Array()
        let words:Results<Words>? = realm.objects(Words.self).filter("categoryId == %@", category.categoryId)
        
        try! realm.write {
            for word in words! {
                word.categoryName = categoryName
                word.updateDate = Date()
                newWords?.append(word)
            }
        }
        return newWords!
    }
    
    //delete category
    func deleteCategory(category: Category) -> Bool{
        let categoryId = category.categoryId
        let words:Results<Words>? = realm.objects(Words.self).filter("categoryId == %@", categoryId)
        
        //update words
        try! realm.write {
            for word in words!{
                word.categoryId = 0
                word.categoryName = "No Category"
                word.updateDate = Date()
            }
        }
        
        //delete category
        try! realm.write {
            realm.delete(category)
        }
        return true
    }
}

/**
 TableView Dalegate
 **/
extension CategoryListViewController: UITableViewDelegate{
    //did select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toWordList", sender: nil)
    }
}

/**
 TableView DataSource
 **/
extension CategoryListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryEntity = categoryEntities{
            return categoryEntity.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories:Category
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem",for: indexPath) as! CategoryTableViewCell
        cell.delegate = self
        categories = categoryEntities![indexPath.row]
        
        cell.categoryTitle.text = categories.categoryName
        cell.categoryTitle.numberOfLines = 0
        cell.categoryTitle.sizeToFit()
        cell.categoryTitle.lineBreakMode = .byClipping
        cell.includeWordsCount.text = String(categories.words.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

/**
 SwipeCellKit SwipeTableViewCellDelegate
 **/
extension CategoryListViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            self.setRegistFrom(category: self.categoryEntities![indexPath.row])
        }
        editAction.transitionDelegate = ScaleTransition.default
        editAction.image = UIImage(named: "Edit")
        editAction.backgroundColor = UIColor.AppColor.editBackGroundColor
        
        let deleteAction = SwipeAction(style: .default, title: "Delete"){ action, indexPath in
            self.setDeleteAlert(category: self.categoryEntities![indexPath.row])
        }
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.image = UIImage(named: "Trash")
        deleteAction.backgroundColor = UIColor.AppColor.deleteBackGroundColor
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        return options
    }
}
