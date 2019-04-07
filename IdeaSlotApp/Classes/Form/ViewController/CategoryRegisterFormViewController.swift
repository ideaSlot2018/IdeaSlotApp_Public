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
        static let popupMessageOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .top, hasBlur: false)
    }
    
    var category: Category? = nil
    var categoryTableView: UITableView!
    var messageView = MessageView.view()
    
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
            me.submit(formView: categoryRegisterFormView)
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

    private func submit(formView: CategoryRegisterFormView) {
        let popupItem = PopupItem(view: messageView,
                                  height: MessageView.Const.height,
                                  maxWidth: Const.maxWidth,
                                  popupOption: Const.popupMessageOption)

        //Register Category
        var result:Bool = false
        let categoryManager = CategoryManager()
        
        if self.category != nil {
            result = categoryManager.update(category: self.category!,newCategoryName: formView.textForm.text!)
        } else {
            result = categoryManager.register(newCategoryName: formView.textForm.text!)
        }
        
        if result {
            messageView.setMessage(title: MessageView.MessageText.infoTitle, message: nil, infoFlg: .info)
            categoryTableView.reloadData()
        }else{
            messageView.setMessage(title: MessageView.MessageText.errorTitle, message: MessageView.MessageText.errorMessage, infoFlg: .error)
        }
        transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
            guard let me = self else { return }
            me.showMessageView()
        }

    }
    
    func showMessageView() {
        let popupItem = PopupItem(view: messageView,
                                  height: MessageView.Const.height,
                                  maxWidth: Const.maxWidth,
                                  popupOption: Const.popupMessageOption)
        
        transformPopupView(duration: Const.transformDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
            guard let me = self else { return }
            me.replacePopupView(with: popupItem)
            
            DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + 1.0 ) { [weak self] in
                guard let me = self else { return }
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction) { _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        }
    }

}
