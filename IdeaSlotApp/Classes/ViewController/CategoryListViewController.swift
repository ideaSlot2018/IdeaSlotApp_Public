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

    let categoryManager = CategoryManager()
    
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
        categoryEntities = categoryManager.getResultsCategory(filterName: nil, filterItem: nil, sort: "categoryId", ascending: true)
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
        setRegisterFrom(category: nil)
    }
    
    //display category register form
    func setRegisterFrom(category:Category?){
        let categoryRegisterFormViewController = CategoryRegisterFormViewController()
        categoryRegisterFormViewController.categoryTableView = self.tableView
        categoryRegisterFormViewController.category = category
        PopupWindowManager.shared.changeKeyWindow(rootViewController: categoryRegisterFormViewController)
    }
    
    //display delete alert
    func setDeleteAlert(category:Category){
        let categoryDeleteAlertViewController = CategoryDeleteAlertViewController()
        categoryDeleteAlertViewController.categoryTableView = self.tableView
        categoryDeleteAlertViewController.category = category
        PopupWindowManager.shared.changeKeyWindow(rootViewController: categoryDeleteAlertViewController)
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
        if let categoryList = categoryEntities{
            return categoryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category:Category = categoryEntities![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem",for: indexPath) as! CategoryTableViewCell

        cell.delegate = self
        cell.categoryTitle.text = category.categoryName
        cell.categoryTitle.numberOfLines = 0
        cell.categoryTitle.sizeToFit()
        cell.categoryTitle.lineBreakMode = .byClipping
        cell.includeWordsCount.text = String(category.words.count)
        
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
            self.setRegisterFrom(category: self.categoryEntities![indexPath.row])
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
