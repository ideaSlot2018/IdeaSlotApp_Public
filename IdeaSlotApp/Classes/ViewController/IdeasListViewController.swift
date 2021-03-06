//
//  IdeasListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import PopupWindow

class IdeasListViewController: UIViewController {
    
    let ideaManager = IdeaManager()
    let categoryManager = CategoryManager()
    
    var ideaEntites:Results<Idea>? = nil
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        setNavigationBarItem()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.register(UINib(nibName: "IdeaItemCell", bundle: nil), forCellReuseIdentifier: "IdeaItem")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ideaEntites = ideaManager.getResultsIdeas(filterName: nil, filterItem: nil, sort: "updateDate", ascending: false)
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toIdeaDetails":
            let ideaDetailsViewController = segue.destination as! IdeaDetailsViewController
            ideaDetailsViewController.idea = ideaEntites![tableView.indexPathForSelectedRow!.row]
        default:
            break
        }
    }
    
    func setDeleteAlert(idea:Idea) {
        let ideaDeleteAlertViewController = IdeaDeleteAlertViewController()
        ideaDeleteAlertViewController.idea = idea
        ideaDeleteAlertViewController.ideaTableView = self.tableView
        PopupWindowManager.shared.changeKeyWindow(rootViewController: ideaDeleteAlertViewController)
    }
    
}

/**
 TableView Delegate
**/
extension IdeasListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.performSegue(withIdentifier: "toIdeaDetails", sender: nil)
    }
    
}

/**
 TabelView DataSource
 **/
extension IdeasListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ideaList = ideaEntites{
            return ideaList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idea:Idea = ideaEntites![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaItem", for: indexPath) as! IdeaTableViewCell
        let linkedCategory = categoryManager.findCategoryItem(categoryId: idea.categoryId)
        
        cell.delegate = self
        cell.idea = idea
        cell.ideaTitle.text = idea.ideaName
        if linkedCategory != nil {
            cell.categoryTitle.text = linkedCategory?.categoryName
        } else {
            cell.categoryTitle.text = "No Category"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

/**
 SwipeCellKit SwipeTableViewCellDelegate
 **/
extension IdeasListViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            self.setDeleteAlert(idea: self.ideaEntites![indexPath.row])
            tableView.reloadData()
        }
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.image = UIImage(named: "Trash")
        deleteAction.backgroundColor = UIColor.AppColor.deleteBackGroundColor
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.transitionStyle = .reveal
        
        return options
    }
}
