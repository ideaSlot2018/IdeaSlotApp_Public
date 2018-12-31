//
//  LeftMenuViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/08/12.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit

enum LeftMenu :Int{
    case words = 0
    case categories
    case ideas
    case slot
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["Words", "Categories", "Ideas", "Idea Slot"]
    var wordsListViewController: UIViewController!
    var categoryListViewController: UIViewController!
    var ideasListViewController: UIViewController!
    var ideasSlotViewController: UIViewController!
    var mainViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.AppColor.backgroundLeftmenu
        self.tableView.separatorColor = UIColor.AppColor.separatorColor
        self.tableView.separatorInset = .zero
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let wordsListViewController = storyboard.instantiateViewController(withIdentifier: "WordsList")as! WordsListViewController
        let categoryListViewController = storyboard.instantiateViewController(withIdentifier: "CategoryList")as! CategoryListViewController
        let ideasListViewController = storyboard.instantiateViewController(withIdentifier: "IdeasList")as! IdeasListViewController
        let ideasSlotViewController = storyboard.instantiateViewController(withIdentifier: "IdeasSlot")as! IdeasSlotViewController
        self.wordsListViewController = UINavigationController(rootViewController: wordsListViewController)
        self.categoryListViewController = UINavigationController(rootViewController: categoryListViewController)
        self.ideasListViewController = UINavigationController(rootViewController: ideasListViewController)
        self.ideasSlotViewController = UINavigationController(rootViewController: ideasSlotViewController)
        
        self.tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .words:
            self.slideMenuController()?.changeMainViewController(wordsListViewController, close: true)
        case .categories:
            self.slideMenuController()?.changeMainViewController(categoryListViewController, close: true)
        case .ideas:
            self.slideMenuController()?.changeMainViewController(ideasListViewController, close: true)
        case .slot:
            self.slideMenuController()?.changeMainViewController(ideasSlotViewController, close: true)
        }
    }
}

extension LeftMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row){
            switch menu{
            case .words, .categories, .ideas, .slot:
                return BaseTableViewCell.Const.height
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row){
            self.changeViewController(menu)
        }
    }
}

extension LeftMenuViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .words, .categories, .ideas, .slot:
                let cell = BaseTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }    
}
