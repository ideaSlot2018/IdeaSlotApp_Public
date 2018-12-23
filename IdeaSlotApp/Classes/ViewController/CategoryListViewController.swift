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

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        setNavigationBarTitle(title: "Category")
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismiss(animated: animated, completion: nil)
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
    
    private func setRegistForm(){
        
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
        cell.includeWordsCount.text = String(categories.words.count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension CategoryListViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            self.setRegistForm()
        }
        editAction.transitionDelegate = ScaleTransition.default
        editAction.image = UIImage(named: "Edit")
        editAction.backgroundColor = UIColor.AppColor.editBackGroundColor
        
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        return options
    }
}
