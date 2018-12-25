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
        static let popupCompletionOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .card, direction: .bottom, hasBlur: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var categoryRegistFormView = CategoryRegistFormView()
        categoryRegistFormView = UINib(nibName: "CategoryRegistFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! CategoryRegistFormView
        
        let popupItem = PopupItem(view: categoryRegistFormView, height: CategoryRegistFormView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        categoryRegistFormView.registerButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.showCompletionView(formView: categoryRegistFormView)
        }
    }
    
    private func showCompletionView(formView: CategoryRegistFormView) {
        print("tap tap tap! :",formView.textFrom.text)
        let popupItem = PopupItem(view: formView, height: CategoryRegistFormView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupCompletionOption)
        transformPopupView(duration: Const.transformDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
            guard let me = self else { return }
            me.replacePopupView(with: popupItem)
            DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + 0.1) { [weak self] in
                guard let me = self else { return }
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction) { _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        }
    }


}
