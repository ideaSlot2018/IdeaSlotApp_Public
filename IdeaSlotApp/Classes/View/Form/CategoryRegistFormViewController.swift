//
//  CategoryRegistFormViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class CategoryRegistFormViewController: BasePopupViewController {
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
        
        var categoryRegistFormView = CategoryRegistFormView()
        categoryRegistFormView = UINib(nibName: "CategoryRegistFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! CategoryRegistFormView
        if self.category?.categoryId != 0 {
            categoryRegistFormView.textFrom.text = self.category?.categoryName
        }
        
        let popupItem = PopupItem(view: categoryRegistFormView, height: CategoryRegistFormView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        categoryRegistFormView.registerButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.showCompletionView(formView: categoryRegistFormView)
        }
        
        categoryRegistFormView.closeButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in }
        }
    }
    
    private func showCompletionView(formView: CategoryRegistFormView) {
        let popupItem = PopupItem(view: formView, height: CategoryRegistFormView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupOption)
        
        //Regist Category
        var result:Bool = false
        let categoryListViewControler = CategoryListViewController()
        result = categoryListViewControler.registCategory(category: self.category!,formText: formView.textFrom.text!)
        if result {
            print("success")
            categoryTableView.reloadData()
            transformPopupView(duration: Const.transformDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.replacePopupView(with: popupItem)
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction) { _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        }else{
            print("failure")
        }
    }    
}
