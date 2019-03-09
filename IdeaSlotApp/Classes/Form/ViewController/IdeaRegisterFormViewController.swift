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
    
    var ideaDto:IdeaDto? = nil
    let categoryManager = CategoryManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ideaRegisterFormView = IdeaRegisterFormView()
        ideaRegisterFormView = UINib(nibName: "IdeaRegisterFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! IdeaRegisterFormView
        ideaRegisterFormView.wordText1.text = ideaDto?.words[0].word
        ideaRegisterFormView.wordText2.text = ideaDto?.words[1].word
        ideaRegisterFormView.operatorName.text = ideaDto?.operator1
        ideaRegisterFormView.dropdown.dataSource = categoryManager.arrayCategoryList(listFlg: 0)

        let popupItem = PopupItem(view: ideaRegisterFormView, height: IdeaRegisterFormView.Const.height, maxWidth: Const.maxWidth, landscapeSize: Const.landscapeSize, popupOption: Const.popupOption)
        configurePopupItem(popupItem)
        
        //category drop dwon tapped
        ideaRegisterFormView.categoryButtonTapHandler = { [weak self] in
            self!.ideaDto?.categoryName = ideaRegisterFormView.categoryName!
        }
        
        //save button tapped
        ideaRegisterFormView.saveButtonTapHandler = { [weak self] in
            guard let me = self else { return }
            me.showCompletionView(formView: ideaRegisterFormView)
        }
        
        //close button tapped
        ideaRegisterFormView.closeButtonTapHandler = { [weak self] in
            self?.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in}
        }
    }
    
    override func tapPopupContainerView(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended && canTapDismiss {
            dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: .bottom) { _ in }
        }
    }
    
    private func showCompletionView(formView: IdeaRegisterFormView){
        let popupItem = PopupItem(view: formView, height: CategoryDeleteAlertView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupOption)
        
        ideaDto?.ideaName = formView.ideaTitle.text
        ideaDto?.details = formView.detailsTextView.text
        
        let ideaSlotViewCotroller = IdeasSlotViewController()
        
        let result:Bool = ideaSlotViewCotroller.registerIdea(newIdea: ideaDto!)
        if result {
            ideaSlotViewCotroller.ideaDto = IdeaDto()
            
            transformPopupView(duration: Const.popupDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
                guard let me = self else { return }
                me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction){ _ in
                    PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                }
            }
        } else {
            print("failure")
        }
        
    }

}
