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

class IdeasListViewController: UIViewController {
    
    let realm = try! Realm()
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
        ideaEntites = realm.objects(Idea.self)
        print(ideaEntites)
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toIdeaDetails":
            let ideaDetailsViewController = segue.destination as! IdeaDetailsViewController
        default:
            break
        }
    }
    
    func deleteIdea(idea: Idea) {
        try! realm.write {
            realm.delete(idea)
        }
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
            print(ideaList.count)
            return ideaList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idea:Idea = ideaEntites![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaItem", for: indexPath) as! IdeaTableViewCell
        
        cell.delegate = self
        cell.idea = idea
        cell.ideaTitle.text = idea.ideaName
        cell.categoryTitle.text = idea.categoryName
        
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
        
        let editAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            self.deleteIdea(idea: self.ideaEntites![indexPath.row])
            tableView.reloadData()
        }
        editAction.image = UIImage(named: "Trash")
        editAction.backgroundColor = UIColor.AppColor.deleteBackGroundColor
        
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.transitionStyle = .reveal
        
        return options
    }
}
