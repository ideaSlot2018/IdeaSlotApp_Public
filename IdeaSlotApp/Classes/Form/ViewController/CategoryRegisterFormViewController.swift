//
//  CategoryRegisterFormViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class CategoryRegisterFormViewController: BasePopupViewController {
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
        
        var categoryRegisterFormView = CategoryRegisterFormView()
        categoryRegisterFormView = UINib(nibName: "CategoryRegisterFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! CategoryRegisterFormView
        if self.category != nil {
            categoryRegisterFormView.textForm.text = self.category?.categoryName
        }
        
        let popupItem = PopupItem(view: categoryRegisterFormView, height: CategoryRegisterFormView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        //register button tapped
        categoryRegisterFormView.registerButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.showCompletionView(formView: categoryRegisterFormView)
        }
        
        //close button tapped
        categoryRegisterFormView.closeButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in }
        }
    }

    override func tapPopupContainerView(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended && canTapDismiss {
            dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in }
        }
    }

    private func showCompletionView(formView: CategoryRegisterFormView) {
        let popupItem = PopupItem(view: formView, height: CategoryRegisterFormView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupOption)
        
        //Register Category
        var result:Bool = false
        let categoryManager = CategoryManager()
        
        if self.category != nil {
            result = categoryManager.update(category: self.category!,newCategoryName: formView.textForm.text!)
        } else {
            result = categoryManager.register(newCategoryName: formView.textForm.text!)
        }
        
        if result {
            categoryTableView.reloadData()
            transformPopupView(duration: Const.transformDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction) { _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        }else{
            print("failure")
        }
    }    
}
