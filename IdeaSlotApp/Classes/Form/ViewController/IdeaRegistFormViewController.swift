//
//  IdeaRegistFormViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/02/11.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class IdeaRegistFormViewController: BasePopupViewController {
    enum Const {
        static let popupDuration: TimeInterval = 0.3
        static let transformDuration: TimeInterval = 0.4
        static let maxWidth: CGFloat = 500
        static let landscapeSize: CGSize = CGSize(width: maxWidth, height: 300)
        static let popupOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .bottom, canTapDismiss: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ideaRegistFormView = IdeaRegistFormView()
        ideaRegistFormView = UINib(nibName: "IdeaRegistFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaRegistFormView
        
        let popupItem = PopupItem(view: ideaRegistFormView, height: IdeaRegistFormView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        ideaRegistFormView.saveButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.showCompletionView(formView: ideaRegistFormView)
        }
    }
    
    private func showCompletionView(formView: IdeaRegistFormView){
        let popupItem = PopupItem(view: formView, height: CategoryDeleteAlertView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupOption)
        
        transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
            guard let me = self else { return }
            me.replacePopupView(with: popupItem)
            me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction){ _ in
                PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
            }
        }
    }

}
