//
//  IdeaDeleteAlertViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/03/24.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class IdeaDeleteAlertViewController: BasePopupViewController {
    enum Const {
        static let popupDuration: TimeInterval = 0.3
        static let transformDuration: TimeInterval = 0.4
        static let maxWidth: CGFloat = 500
        static let landscapeSize: CGSize = CGSize(width: maxWidth, height: 300)
        static let popupOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .bottom, canTapDismiss: true)
        static let popupMessageOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .top, hasBlur: false)
    }
    
    var idea: Idea? = nil
    var ideaTableView: UITableView!
    var messageView = MessageView.view()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ideaDeleteAlertView = IdeaDeleteAlertView()
        ideaDeleteAlertView = UINib(nibName: "IdeaDeleteAlertView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaDeleteAlertView
        if idea != nil {
            ideaDeleteAlertView.deleteDescription.text = "Do you really want to delete \' \(idea!.ideaName!) \' ?"
        }
        
        let popupItem = PopupItem(view: ideaDeleteAlertView, height: CategoryDeleteAlertView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)

        //cansel button tapped
        ideaDeleteAlertView.canselButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in}
        }
        
        //close button tapped
        ideaDeleteAlertView.closeButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in}
        }
        
        //delete button tapped
        ideaDeleteAlertView.deleteButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.submit(formView: ideaDeleteAlertView)
        }
    }
    
    override func tapPopupContainerView(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended && canTapDismiss {
            dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in }
        }
    }
    
    private func submit(formView: IdeaDeleteAlertView){
        let popupItem = PopupItem(view: messageView,
                                  height: MessageView.Const.height,
                                  maxWidth: Const.maxWidth,
                                  popupOption: Const.popupMessageOption)

        //delete Idea
        let ideaManager = IdeaManager()
        if !ideaManager.delete(idea: idea!) {
            messageView.setMessage(title: MessageView.MessageText.errorTitle, message: MessageView.MessageText.errorMessage, infoFlg: .error)
            transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.showMessageView()
            }
        } else {
            ideaTableView.reloadData()
            transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction){ _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
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
