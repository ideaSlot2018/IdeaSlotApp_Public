//
//  CategoryRegistFormViewController.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/19.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow
import RealmSwift

class CategoryRegistFormViewController: BasePopupViewController {
    enum Const {
        static let popupDuration: TimeInterval = 0.3
        static let transformDuration: TimeInterval = 0.4
        static let maxWidth: CGFloat = 500
        static let landscapeSize: CGSize = CGSize(width: maxWidth, height: 300)
        static let popupOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .toast, direction: .bottom, canTapDismiss: true)
        static let popupCompletionOption = PopupOption(shapeType: .roundedCornerTop(cornerSize: 8), viewType: .card, direction: .bottom, hasBlur: false)
    }
    
    var category: Category? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var categoryRegistFormView = CategoryRegistFormView()
        categoryRegistFormView = UINib(nibName: "CategoryRegistFormView", bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first! as! CategoryRegistFormView
        if appDelegate.category != nil {
            self.category = appDelegate.category
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
            self!.appDelegate.category = nil
        }
    }
    
    private func showCompletionView(formView: CategoryRegistFormView) {
        
        if self.category == nil {
            self.category = Category()
        }
        
        //Regist Category
        var result:Bool = false
        result = registCategory(category: self.category!,formText: formView.textFrom.text!)
        if result {
            print("success")
        }else{
            print("failure")
        }
        
        
        let popupItem = PopupItem(view: formView, height: CategoryRegistFormView.Const.height, maxWidth: Const.maxWidth, popupOption: Const.popupCompletionOption)
        transformPopupView(duration: Const.transformDuration, curve: .easeInOut, popupItem: popupItem) { [weak self] _ in
            guard let me = self else { return }
            //            me.replacePopupView(with: popupItem)
            me.dismissPopupView(duration: Const.popupDuration, curve: .easeInOut, direction: popupItem.popupOption.direction) { _ in
                PopupWindowManager.shared.changeKeyWindow(rootViewController: nil)
                self!.appDelegate.category = nil
            }
        }
        
    }
    
    func registCategory(category: Category, formText: String) -> Bool {
        let item: [String: Any]
        
        if category.categoryId != 0 {
            let newWords = self.convertWords(categoryName: formText)
            item = ["categoryId":category.categoryId,
                    "categoryName":formText,
                    "words":newWords,
                    "createDate":category.createDate
            ]
        }else{
            item = ["categoryId":getCategoryMaxId(),
                    "categoryName":formText,
            ]
        }
        
        let editCategory = Category(value: item)
        try! realm.write {
            realm.add(editCategory, update: true)
        }
        
        return true
    }
    
    private func convertWords(categoryName:String) -> Array<Words>{
        var newWords:Array<Words>? = Array()
        let words:Results<Words>? = realm.objects(Words.self).filter("categoryId == %@", category!.categoryId)
        
        try! realm.write {
            for word in words! {
                word.categoryName = categoryName
                newWords?.append(word)
            }
        }
        return newWords!
    }
    
}
