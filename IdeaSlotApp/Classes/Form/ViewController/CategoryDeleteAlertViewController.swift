//
//  CategoryDeleteAlertViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/01/05.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class CategoryDeleteAlertViewController: BasePopupViewController {
    enum Const {
        static let popupDuration: TimeInterval = 0.3
        static let transformDuration: TimeInterval = 0.4
        static let maxWidth: CGFloat = 500
        static let landscapeSize: CGSize = CGSize(width: maxWidth, height: 300)
        static let popupOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .bottom, canTapDismiss: true)
    }
    
    var category: Category? = nil
    var categoryTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var categoryDeleteAlertView = CategoryDeleteAlertView()
        categoryDeleteAlertView = UINib(nibName: "CategoryDeleteAlertView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! CategoryDeleteAlertView
        if self.category != nil {
            categoryDeleteAlertView.deleteDescription.text = "Do you really want to delete \" \(category!.categoryName) \" ?"
        }
        
        let popupItem = PopupItem(view: categoryDeleteAlertView, height: CategoryDeleteAlertView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        //cansel button tapped
        categoryDeleteAlertView.canselButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in}
        }
        
        //close button tapped
        categoryDeleteAlertView.closeButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in}
        }
        
        //delete button tapped
        categoryDeleteAlertView.deleteButtonTapHandler = { [weak self] in
            guard  let me = self else { return }
            me.showCompletionView(alertView: categoryDeleteAlertView)
        }
    }
    
    private func showCompletionView(alertView: CategoryDeleteAlertView){
        let popupItem = PopupItem(view: alertView, height: CategoryDeleteAlertView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupOption)
        
        //delete Category
        var result:Bool = false
        let categoryListViewController = CategoryListViewController()
        result = categoryListViewController.deleteCategory(category: self.category!)
        
        if result {
            categoryTableView.reloadData()
            transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.replacePopupView(with: popupItem)
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction){ _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        } else {
            print("failure")
        }
    }
}
