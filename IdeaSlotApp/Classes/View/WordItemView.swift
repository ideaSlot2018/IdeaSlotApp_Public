//
//  WordItemView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/11/10.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import DropDown

protocol InputTextDelegate {
    func textFieldDidEndEditing(item: WordItemView, value: String) ->()
}

class WordItemView: UIView {
    enum Const {
        static let height:CGFloat = 55.0
    }
    
    @IBOutlet weak var textfield: UITextField!{
        didSet{
            textfield.placeholder = "please type word and press enter"
            textfield.delegate = self
        }
    }
    
    @IBOutlet weak var categorybutton: UIButton!{
        didSet{
            categorybutton.setTitle("No Category", for: .normal)
            categorybutton.backgroundColor = UIColor.AppColor.buttonColor
            categorybutton.tintColor = UIColor.AppColor.buttonTextColor
            categorybutton.layer.cornerRadius = 5.0
            categorybutton.layer.masksToBounds = true
            categorybutton.titleLabel?.lineBreakMode = .byTruncatingTail
        }
    }
    var delegate:InputTextDelegate! = nil
    var categoryName: String? = ""
    var wordId: String? = ""
    var beforeWord: String? =  ""
    var beforecategoryName: String? = ""
    var wordItemViewTapHandler:(() -> Void)?
    var tapFlg = false
    
    let dropdown = DropDown()
    
    @IBAction func showDropdown(_ sender: Any) {
        dropdown.show()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDropDown(button: categorybutton, dropdown: dropdown)
        textfield.isEnabled = false
        
        self.isUserInteractionEnabled = true
//
//        let doubleTap =  UITapGestureRecognizer(target: self, action: #selector(self.doubleTapAction(sender:)))
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.numberOfTouchesRequired = 1
//        self.addGestureRecognizer(doubleTap)
//
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapAction(sender:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
//        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(singleTap)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDropDown(button:UIButton, dropdown:DropDown){
        dropdown.anchorView = button
        dropdown.selectionAction = {(index, item) in
            button.setTitle(item, for: .normal)
            self.categoryName = item
            if self.categoryName != self.beforecategoryName {
                self.textFieldDidEndEditing(self.textfield)
            }
        }
    }
    
    @objc func singleTapAction(sender: UIGestureRecognizer) {
        tapFlg = true
        wordItemViewTapHandler?()
    }

//    @objc func doubleTapAction(sender: UIGestureRecognizer) {
//        tapFlg = false
//        wordItemViewTapHandler?()
//    }
}

extension WordItemView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty{
            self.delegate.textFieldDidEndEditing(item: self, value: textField.text!)
        }
    }
}
