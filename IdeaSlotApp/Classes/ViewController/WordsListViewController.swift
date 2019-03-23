//
//  WordsListViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/07/22.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class WordsListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var wordEntities:Results<Words>? = nil
    var category:Category? = nil
    var searchController:UISearchController!
    var filteredWords = [Words]()
    var wordList = [Words]()
    var linkedIdea:Idea? = nil
    
    let wordManager = WordManager()
    let categoryManager = CategoryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        if category == nil{
            setNavigationBarItem()
        }else{
            customBackButton()
        }
        setSearchController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if category != nil {
            wordEntities = wordManager.getResultsByLinkedCategory(categoryId: category!.categoryId, sort: "updateDate", ascending: false)
        }else{
            wordEntities = wordManager.getResultsWords(filterName: nil, filterItem: nil, sort: "updateDate", ascending: false)
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func registerWord(Id: String, wordName: String, categoryName: String){
        let item:Words? = wordManager.getResultByWordId(wordId: Id)
        let categoryItem:Category? = categoryManager.findCategoryItem(categoryName: categoryName)
        var result:Bool = false
        
        if item == nil{
            //register
            result = wordManager.insert(wordName: wordName, category: categoryItem)
        }else{
            //update
            result = wordManager.update(wordName: wordName, category: categoryItem, wordItem: item!)
        }
        print(result)
        tableView.reloadData()
    }
    
    //set up searchcontroller
    func setSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = UIColor.AppColor.navigationTitle
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        }else{
            self.navigationItem.titleView = searchController.searchBar
        }
        self.definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toIdeaDetailsFromWord":
            let ideaDetailsViewController = segue.destination as! IdeaDetailsViewController
            ideaDetailsViewController.idea = linkedIdea
        default:
            break
        }
    }

    
}

/**
 TableView Delegate
 **/
extension WordsListViewController: UITableViewDelegate{
    
    /**
     display tableview header
     **/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView()
        headerview.backgroundColor = UIColor.AppColor.backgroundHeader
        
        var item = WordItemView()
        item = Bundle.main.loadNibNamed("WordItemView", owner: self, options: nil)!.first! as! WordItemView
        item.delegate = self
        item.dropdown.dataSource = categoryManager.arrayCategoryList(listFlg: 0)
        if category != nil{
            item.categorybutton.setTitle(category?.categoryName, for: .normal)
        }
        item.addBottomBorder(view: item.textfield, height: 1.0, color: UIColor.gray.cgColor)
        
        if #available(iOS 11.0, *) {
            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 55)
            item.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:WordItemView.Const.height)
        } else {
            headerview.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 55)
            item.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:WordItemView.Const.height)
        }
        headerview.addSubview(item)
        
        return headerview
    }
    
    /**
     tableview header height size
     **/
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if #available(iOS 11.0, *) {
            return WordItemView.Const.height
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WordItemView.Const.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return WordItemView.Const.height
    }
    
}

/**
 TableView DataSource
 **/
extension WordsListViewController: UITableViewDataSource{
    //display cell count
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredWords.count
        } else {
            if let wordEntities = wordEntities{
                return wordEntities.count
            }
        }
        return 0
    }
    
    //display cell details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let words: Words
        let cell = SwipeTableViewCell()
        cell.delegate = self
        
        var itemView = WordItemView()
        itemView = UINib(nibName: "WordItemView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! WordItemView
        itemView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        itemView.delegate = self
        itemView.dropdown.dataSource = categoryManager.arrayCategoryList(listFlg: 0)
        //filterd or not
        if isFiltering(){
            words = filteredWords[indexPath.row]
        }else{
            words = wordEntities![indexPath.row]
        }
        
        //idea ro word
        if words.ideaFlg == 1 {
            itemView.textfield.font = UIFont.italicSystemFont(ofSize: 25)
            itemView.textfield.isEnabled = false
            itemView.categorybutton.isEnabled = false
            itemView.wordItemViewTapHandler = { [weak self] in
                self!.linkedIdea = words.idea.first
                self?.performSegue(withIdentifier: "toIdeaDetailsFromWord", sender: nil)
            }
        } else {
            itemView.addBottomBorder(view: itemView.textfield, height: 1.0, color: UIColor.gray.cgColor)
            itemView.textfield.isEnabled = true
//            itemView.wordItemViewTapHandler = { [weak self] in
//            }
        }
        
        itemView.textfield.text = words.word
        itemView.wordId = words.wordId
        itemView.beforeWord = words.word
        
        //set category name
        if words.category.first != nil {
            itemView.categorybutton.setTitle(words.category.first?.categoryName, for: .normal)
            itemView.categoryName = words.category.first?.categoryName
            itemView.beforecategoryName = words.category.first?.categoryName
        } else {
            itemView.categorybutton.setTitle("No Category", for: .normal)
            itemView.categoryName = "No Category"
            itemView.beforecategoryName = "No Category"
        }

        cell.contentView.addSubview(itemView)
        return cell
    }
}

/**
 Textfield Delegate(extension WordTableViewCell)
 **/
extension WordsListViewController: InputTextDelegate{
    //textfield has finished to edit
    func textFieldDidEndEditing(item: WordItemView, value: String) -> () {
        if value != item.beforeWord || item.categoryName != item.beforecategoryName {
            registerWord(Id: item.wordId!, wordName: value, categoryName: item.categoryName!)
        }
    }
}

/**
 SearchController SearchResultUpdating
 **/
extension WordsListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        wordList = Array(wordEntities!)
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        
        let searchtext = searchController.searchBar.text!
        filteredWords = wordList.filter({( words : Words) -> Bool in
            return words.word!.lowercased().contains(searchtext.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        //Returns true if search bar is active and text is not empty or nil
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

/**
 SwipeCellKit SwipeTableViewCellDelegate
 **/
extension WordsListViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            let result:Bool = self.wordManager.delete(word: self.wordEntities![indexPath.row])
            tableView.reloadData()
        }
        deleteAction.image = UIImage(named: "Trash")
        deleteAction.backgroundColor = UIColor.AppColor.deleteBackGroundColor

        let word = wordEntities![indexPath.row]
        if word.ideaFlg == 0 {
            return [deleteAction]
        }
        return []
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.transitionStyle = .reveal
        
        return options
    }
}
