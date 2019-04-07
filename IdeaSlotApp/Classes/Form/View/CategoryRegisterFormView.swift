//
//  CategoryRegisterFormView.swift
//  IdeaSlotApp
//
//  Created by yuta akazawa on 2018/12/16.
//  Copyright © 2018年 yuta akazawa. All rights reserved.
//

import UIKit
import PopupWindow

class CategoryRegisterFormView: UIView, PopupViewContainable{
    enum Const {
        static let height: CGFloat = 500
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var textForm: UITextField!{
        didSet{
            textForm.placeholder = "Please type in 15 characters"
        }
    }
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.setTitle("Continue", for: .normal)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            registerButton.backgroundColor = UIColor.AppColor.buttonColor
            registerButton.tintColor = UIColor.AppColor.buttonTextColor
            registerButton.layer.cornerRadius = 5.0
            registerButton.layer.masksToBounds = true
            registerButton.isEnabled = false
        }
    }
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.setImage(UIImage(named:"Close"), for: .normal)
            closeButton.imageView?.tintColor = UIColor.gray
        }
    }
    
    @IBAction func RegisterAction(_ sender: Any) {
        registerButtonTapHandler?()
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        closeButtonTapHandler?()
    }
    
    var registerButtonTapHandler: (() -> Void)?
    var closeButtonTapHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.backgroundColor = UIColor.AppColor.formBackgroundColor
        addBottomBorder(view: textForm, height: 2.0, color: UIColor.darkGray.cgColor)
        NotificationCenter.default.addObserver(self, selector: #selector(changeNotifyTextField(sender:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //notify textForm's change
    @objc public func changeNotifyTextField (sender: NSNotification) {
        guard let textfield = sender.object as? UITextField else {
            return
        }
        if textfield.text != nil {
            registerButton.isEnabled = textfield.text != ""
        }
    }
}

