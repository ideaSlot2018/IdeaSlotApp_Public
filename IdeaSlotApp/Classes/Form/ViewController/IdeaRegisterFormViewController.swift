//
//  IdeaRegisterFormViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2019/02/11.
//  Copyright © 2019年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class IdeaRegisterFormViewController: BasePopupViewController {
    enum Const {
        static let popupDuration: TimeInterval = 0.3
        static let transformDuration: TimeInterval = 0.4
        static let maxWidth: CGFloat = 500
        static let landscapeSize: CGSize = CGSize(width: maxWidth, height: 300)
        static let popupOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .bottom, canTapDismiss: true)
    }
    
    var ideaItem:Idea? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ideaItem)
        
        var ideaRegisterFormView = IdeaRegisterFormView()
        ideaRegisterFormView = UINib(nibName: "IdeaRegisterFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaRegisterFormView
        ideaRegisterFormView.wordText1.text = ideaItem?.words[0].word
        ideaRegisterFormView.wordText2.text = ideaItem?.words[1].word
        ideaRegisterFormView.operatorName.text = ideaItem?.operatorId1
        ideaRegisterFormView.dropdown.dataSource = arrayCategoryList(listFlg: 0)

        let popupItem = PopupItem(view: ideaRegisterFormView, height: IdeaRegisterFormView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        ideaRegisterFormView.saveButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.showCompletionView(formView: ideaRegisterFormView)
        }
    }
    
    private func showCompletionView(formView: IdeaRegisterFormView){
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
