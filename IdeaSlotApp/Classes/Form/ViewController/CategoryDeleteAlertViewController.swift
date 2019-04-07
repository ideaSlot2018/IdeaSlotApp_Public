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
        static let popupMessageOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .top, hasBlur: false)
    }
    
    var category: Category? = nil
    var categoryTableView: UITableView!
    var messageView = MessageView.view()

    override func viewDidLoad() {
        super.viewDidLoad()

        var categoryDeleteAlertView = CategoryDeleteAlertView()
        categoryDeleteAlertView = UINib(nibName: "CategoryDeleteAlertView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! CategoryDeleteAlertView
        if self.category != nil {
            categoryDeleteAlertView.deleteDescription.text = "Do you really want to delete \' \(category!.categoryName) \' ?"
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
            me.submit(formView: categoryDeleteAlertView)
        }
    }
    
    override func tapPopupContainerView(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended && canTapDismiss {
            dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in }
        }
    }
    
    private func submit(formView: CategoryDeleteAlertView){
        let popupItem = PopupItem(view: messageView,
                                  height: MessageView.Const.height,
                                  maxWidth: Const.maxWidth,
                                  popupOption: Const.popupMessageOption)

        //delete Category
        let categoryManager = CategoryManager()
        if categoryManager.delete(category: self.category!) {
            categoryTableView.reloadData()
            transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction){ _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        } else {
            messageView.setMessage(title: MessageView.MessageText.errorTitle, message: MessageView.MessageText.errorMessage, infoFlg: .error)
            transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.showMessageView()
            }
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
